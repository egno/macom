unit dbfunc;

{
MaCom - Free/Libre Management Company Information System
Database functions unit

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
  Classes, SysUtils, ComCtrls, sqldb,
  db, extsqlquery, keyvalue;

  procedure DBConnect(Conn: TSQLConnection;
    cUser, cPwd, cHost, cPort, cBase: String);
  procedure DBDisconnect(Conn: TSQLConnection);
  function GetQuery(Conn: TSQLConnection): TSQLQuery;
  procedure FillListFromQuery(Conn: TSQLConnection; Items: TStrings; SQL:String);
  function ListToString(aList: TStrings; aDelimiter, aQuote: String): String;
  function ExecSQL(Conn: TSQLConnection; SQL: String): String;
  function ReturnStringSQL(Conn: TSQLConnection; SQL: String): String;




implementation

procedure DBConnect(Conn: TSQLConnection; cUser, cPwd,
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

procedure DBDisconnect(Conn: TSQLConnection);
begin
  Conn.Connected:=False;
  Conn.Params.Clear;
end;

function GetQuery(Conn: TSQLConnection) : TSQLQuery;
  var aQuery : TSQLQuery;
begin
  aQuery := TSQLQuery.Create(Conn);
  aQuery.Database := Conn;
  aQuery.Transaction := Conn.Transaction;
  Result := aQuery;
end;

procedure FillListFromQuery(Conn: TSQLConnection; Items: TStrings; SQL: String);
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

function ListToString(aList: TStrings; aDelimiter, aQuote: String): String;
var
  i: Integer;
  res: String;
begin
  res := '';
  for i:=0 to aList.Count-1 do begin
    if length(res) > 0 then res:=res+aDelimiter;
    res := res + aQuote + aList[i] + aQuote;
  end;
  Result:=res;
end;


function ExecSQL(Conn: TSQLConnection; SQL: String): String;
var
  Query: TExtSQLQuery;
begin
  Query := TExtSQLQuery.Create(nil, Conn);
  try
    Query.SQL.Add(SQL);
    Query.ExecSQL;
    Query.Close;
  finally
    Query.Free;
  end;
end;

function ReturnStringSQL(Conn: TSQLConnection; SQL: String): String;
var
  Query: TExtSQLQuery;
begin
  Query := TExtSQLQuery.Create(nil, Conn);
  try
    Query.SQL.Add(SQL);
    Query.Open;
    Result := Query.Fields[0].AsString;
  except
    Result := '';
  end;
  Query.Free;
end;


end.

