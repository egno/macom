{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dbvcextended;

interface

uses
  DBDynTreeView, dbfunc, keyvalue, ExtSQLQuery, DBVST, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('DBDynTreeView', @DBDynTreeView.Register);
  RegisterUnit('ExtSQLQuery', @ExtSQLQuery.Register);
  RegisterUnit('DBVST', @DBVST.Register);
end;

initialization
  RegisterPackage('dbvcextended', @Register);
end.
