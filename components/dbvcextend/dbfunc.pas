unit dbfunc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, sqldb,
  pqconnection, extsqlquery, keyvalue;

  procedure DBConnect(Conn: TPQConnection;
    cUser, cPwd, cHost, cPort, cBase: String);
  procedure DBDisconnect(Conn: TPQConnection);
  procedure DBFillTreeNodes(Conn: TPQConnection; Nodes: TTreeNodes;
    table, key, parent, display: String);
  function GetQuery(Conn: TPQConnection): TSQLQuery;
  procedure FillListFromQuery(Conn: TPQconnection; Items: TStrings; SQL:String);


implementation

procedure DBConnect(Conn: TPQConnection; cUser, cPwd,
  cHost, cPort, cBase: String);
begin
  DBDisconnect(Conn);

  Conn.UserName:=cUser;
  Conn.Password:=cPwd;
  Conn.HostName:=cHost;
  Conn.DatabaseName:=cBase;
  Conn.Params.Add('port=' + cPort);

  try
    Conn.Connected:=True;
  except
    on E: Exception do begin
//      DBConnect:=('Ошибка при подключении к базе данных: ' + E.Message);
    end;
  end;
end;

procedure DBDisconnect(Conn: TPQConnection);
begin
  Conn.Connected:=False;
  Conn.Params.Clear;
end;

procedure DBFillTreeNodes(Conn: TPQConnection; Nodes: TTreeNodes; table, key,
  parent, display: String);

  procedure DBFillNode(SQL: String; pid: String; Node: TTreeNode);
  var
    Query: TSQLQuery;
    NodeData: TKeyValue;
    NewNode: TTreeNode;
  begin
    try
      Query := GetQuery(Conn);
      if not assigned(Node) then
        Query.SQL.Text := SQL + ' where ' + parent + ' is null'
      else
        Query.SQL.Text := SQL + ' where ' + parent + ' = ''' + pid + '''';
      Query.Open;
      writeln(Query.SQL.Text);
      while not Query.Eof do
      begin
        NodeData:=TKeyValue.Create(Query.Fields[0].AsString, Query.Fields[1].AsString);
        if Assigned(Node) then begin
          NewNode := Nodes.AddChildObject(Node, NodeData.Value, NodeData);
        end
        else begin
          NewNode := Nodes.AddObject(Node, NodeData.Value, NodeData);
        end;
        DBFillNode(SQL, Query.Fields[0].AsString, NewNode);
        Query.Next;
      end;
      Query.Close;
      Query.Destroy;
    except
      on E: Exception do
        Writeln(E.Message);
    end;
  end;

var
  SQL: String;
begin
  SQL := 'select ' + key + ', ' + display
    + ' from ' + table + ' ';
  DBFillNode(SQL, '', nil);
end;

function GetQuery(Conn: TPQConnection) : TSQLQuery;
  var aQuery : TSQLQuery;
begin
  aQuery := TSQLQuery.Create(Conn);
  aQuery.Database := Conn;
  aQuery.Transaction := Conn.Transaction;
  Result := aQuery;
end;

procedure FillListFromQuery(Conn: TPQconnection; Items: TStrings; SQL: String);
var
  Query: TExtSQLQuery;
begin
  try
    Query := TExtSQLQuery.Create(nil, Conn);
    Query.SQL.Text := SQL;
    Query.Open;
    Items.Clear;
    while not Query.Eof do
    begin
      Items.Add(Query.Fields[0].AsString);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;


end.

