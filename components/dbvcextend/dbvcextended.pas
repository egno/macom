{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dbvcextended;

interface

uses
  dbfunc, keyvalue, ExtSQLQuery, DBVST, VSTCombo, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ExtSQLQuery', @ExtSQLQuery.Register);
  RegisterUnit('DBVST', @DBVST.Register);
end;

initialization
  RegisterPackage('dbvcextended', @Register);
end.
