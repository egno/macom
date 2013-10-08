unit DBDynTreeView;

{
MaCom - Free/Libre Management Company Information System
TTreeView mod

Copyright (C) 2013 Alexandr Shelemetyev
https://github.com/egno/macom

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/

Текст лицензии на русском: http://rusgpl.ru/
}


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  pqconnection, sqldb,
//  VirtualTrees,
  keyvalue, extsqlquery;


type

  THookStringList = class(TStringList);
  THookConnection = class(TPQConnection);

  { TDBDynTreeView }

  TDBDynTreeView = class(TTreeView)
  private
    FKey: String;
    FConnection: TPQConnection;
    FSQL: TStringList;
    procedure SetConnection(AValue: TPQConnection);
    procedure SetKey(AValue: String);
    procedure SetSQL(AValue: TStringList);

    { Private declarations }
  protected
    { Protected declarations }
    procedure Expanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
  public
    { Public declarations }
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure Fill(Node: TTreeNode);
    procedure FillFromQuery(conn: TPQConnection; Qry: String);
  published
    { Published declarations }
    property SQL: TStringList read FSQL write SetSQL;
    property Key: String read FKey write SetKey;
    property Connection: TPQConnection read FConnection write SetConnection;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Data Controls',[TDBDynTreeView]);
end;


{ TDBDynTreeView }


procedure TDBDynTreeView.SetConnection(AValue: TPQConnection);
begin
  if FConnection=AValue then Exit;
  FConnection:=AValue;
end;

procedure TDBDynTreeView.SetSQL(AValue: TStringList);
begin
  if FSQL=AValue then Exit;
  FSQL:=AValue;
end;

procedure TDBDynTreeView.Expanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  (Sender as TDBDynTreeView).Fill(Node);
end;

procedure TDBDynTreeView.SetKey(AValue: String);
begin
  if FKey=AValue then Exit;
  FKey:=AValue;
end;

constructor TDBDynTreeView.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FConnection:=TPQConnection.Create(Self);
  FConnection.SetSubComponent(true);
  FSQL:=TStringList.Create();
  OnExpanding:=@Expanding;
  //Include(THookConnection(FConnection).FComponentStyle, csSubComponent);
end;

destructor TDBDynTreeView.Destroy;
begin
//  Query.Close;
//  Query.Free;
  inherited Destroy;
end;


procedure TDBDynTreeView.Fill(Node: TTreeNode);
var
  Query: TExtSQLQuery;
  NewNode : TTreeNode;
  NodeData: TKeyValue;
begin
  if (Node <> nil) and (Node.HasChildren) then
      if (Node.GetFirstChild.Data = nil) then
         Node.DeleteChildren
      else
         Exit;
  try
    Query := TExtSQLQuery.Create(Self, FConnection);
    if (Node = nil) then
       Query.SQL.Text := FSQL.Text + ' is null order by 2'
    else
       Query.SQL.Text := FSQL.Text + ' = ''' + TKeyValue(Node.Data).Code + ''' order by 2';
    Query.Open;
    while not Query.Eof do
    begin
      NodeData:=TKeyValue.Create(Query.Fields[0].AsString, Query.Fields[1].AsString);
      if Assigned(Node) then begin
        NewNode := Items.AddChildObject(Node, NodeData.Value, NodeData);
      end
      else begin
        NewNode := Items.AddObject(Node, NodeData.Value, NodeData);
      end;
      Items.AddChildObject(NewNode, '', nil);
//      Fill(NewNode);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TDBDynTreeView.FillFromQuery(conn: TPQConnection; Qry: String);
begin
  Self.Items.Clear;
  Self.SQL.Clear;
  Self.SQL.Add(Qry);
  Self.Connection:=conn;
  Self.Fill(nil);
end;

end.
