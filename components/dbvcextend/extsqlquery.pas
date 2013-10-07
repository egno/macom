unit ExtSQLQuery;

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

end.
