unit ExtSQLQuery;

{
MaCom - Free/Libre Management Company Information System
TSQLQuery extension

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
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, sqldb;

type

  { TExtSQLQuery }

  TExtSQLQuery = class(TSQLQuery)
  private
    { Private declarations }
    FTrans: TSQLTransaction;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(TheOwner: TComponent); override;
    constructor Create(TheOwner: TComponent; Conn: TSQLConnection);
    destructor Destroy; override;
    procedure Open();
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SQLdb',[TExtSQLQuery]);
end;

{ TExtSQLQuery }

constructor TExtSQLQuery.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
end;

constructor TExtSQLQuery.Create(TheOwner: TComponent; Conn: TSQLConnection);
begin
  inherited Create(TheOwner);
  FTrans:=TSQLTransaction.Create(TheOwner);
  FTrans.DataBase:=Conn;
  Self.DataBase:=Conn;
  Self.Transaction:=FTrans;
end;

destructor TExtSQLQuery.Destroy;
begin
  FTrans.Commit;
  Self.Close;
  Self.DataBase:=nil;
  FTrans.DataBase:=nil;
  FTrans.Free;
  FTrans:=nil;
  inherited Destroy;
end;

procedure TExtSQLQuery.Open;
begin
//  writeln('Open query: '+SQL.Text);
  inherited Open;
end;

end.
