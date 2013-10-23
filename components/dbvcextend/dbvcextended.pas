{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dbvcextended;

interface

uses
  dbfunc, keyvalue, ExtSQLQuery, DBVST, VSTCombo, PanelRollOut, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ExtSQLQuery', @ExtSQLQuery.Register);
  RegisterUnit('DBVST', @DBVST.Register);
  RegisterUnit('PanelRollOut', @PanelRollOut.Register);
end;

initialization
  RegisterPackage('dbvcextended', @Register);
end.
