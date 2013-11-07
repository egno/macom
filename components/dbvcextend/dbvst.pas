unit DBVST;

{
MaCom - Free/Libre Management Company Information System
VirtualTrees mod

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
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  sqldb, extsqlquery, db, dbfunc, pqconnection,
  VirtualTrees, VSTCombo;

type

  { TDBVMemo }

  TDBVMemo = class(TMemo)
  private
    FConnection: TPQConnection;
    FDBField: String;
    FDBFieldConvFrom: String;
    FDBFieldConvTo: String;
    FDBTable: String;
    FLinkFields: TStrings;
    FMasterControls: TStrings;
    FWhere: String;
    FText: String;
    procedure SetConnection(AValue: TPQConnection);
    procedure SetDBField(AValue: String);
    procedure SetDBFieldConvFrom(AValue: String);
    procedure SetDBFieldConvTo(AValue: String);
    procedure SetDBTable(AValue: String);
    procedure SetLinkFields(AValue: TStrings);
    procedure SetMasterControls(AValue: TStrings);
    procedure SetWhere(AValue: String);
  protected
    procedure OnExitExecute(Sender: TObject);
  public
    procedure ReFill();
    procedure Save();
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DBTable: String read FDBTable write SetDBTable;
    property DBField: String read FDBField write SetDBField;
    property DBFieldConvTo: String read FDBFieldConvTo write SetDBFieldConvTo;
    property DBFieldConvFrom: String read FDBFieldConvFrom write SetDBFieldConvFrom;
    property DBMasterControls: TStrings read FMasterControls write SetMasterControls;
    property DBLinkFields: TStrings read FLinkFields write SetLinkFields;
    property Where: String read FWhere write SetWhere;
    property Connection: TPQConnection read FConnection write SetConnection;
  end;


  { TDBVEdit }

  TDBVEdit = class(TEdit)
  private
    FConnection: TPQConnection;
    FDBField: String;
    FDBFieldConvFrom: String;
    FDBFieldConvTo: String;
    FDBTable: String;
    FLinkFields: TStrings;
    FMasterControls: TStrings;
    FWhere: String;
    FText: String;
    procedure SetConnection(AValue: TPQConnection);
    procedure SetDBField(AValue: String);
    procedure SetDBFieldConvFrom(AValue: String);
    procedure SetDBFieldConvTo(AValue: String);
    procedure SetDBTable(AValue: String);
    procedure SetLinkFields(AValue: TStrings);
    procedure SetMasterControls(AValue: TStrings);
    procedure SetWhere(AValue: String);
  protected
    procedure OnExitExecute(Sender: TObject);
  public
    procedure ReFill();
    procedure Save();
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DBTable: String read FDBTable write SetDBTable;
    property DBField: String read FDBField write SetDBField;
    property DBFieldConvTo: String read FDBFieldConvTo write SetDBFieldConvTo;
    property DBFieldConvFrom: String read FDBFieldConvFrom write SetDBFieldConvFrom;
    property DBMasterControls: TStrings read FMasterControls write SetMasterControls;
    property DBLinkFields: TStrings read FLinkFields write SetLinkFields;
    property Where: String read FWhere write SetWhere;
    property Connection: TPQConnection read FConnection write SetConnection;
  end;


  { TDBVCombo }

  TDBVCombo = class(TComboBox)
  private
    FConnection: TPQConnection;
    FDBField: String;
    FDBFieldConvFrom: String;
    FDBFieldConvTo: String;
    FDBTable: String;
    FLinkFields: TStrings;
    FMasterControls: TStrings;
    FWhere: String;
    FText: String;
    procedure SetConnection(AValue: TPQConnection);
    procedure SetDBField(AValue: String);
    procedure SetDBFieldConvFrom(AValue: String);
    procedure SetDBFieldConvTo(AValue: String);
    procedure SetDBTable(AValue: String);
    procedure SetLinkFields(AValue: TStrings);
    procedure SetMasterControls(AValue: TStrings);
    procedure SetWhere(AValue: String);
  protected
    procedure OnExitExecute(Sender: TObject);
  public
    procedure ReFill();
    procedure Save();
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DBTable: String read FDBTable write SetDBTable;
    property DBField: String read FDBField write SetDBField;
    property DBFieldConvTo: String read FDBFieldConvTo write SetDBFieldConvTo;
    property DBFieldConvFrom: String read FDBFieldConvFrom write SetDBFieldConvFrom;
    property DBMasterControls: TStrings read FMasterControls write SetMasterControls;
    property DBLinkFields: TStrings read FLinkFields write SetLinkFields;
    property Where: String read FWhere write SetWhere;
    property Connection: TPQConnection read FConnection write SetConnection;
  end;



  { TDBVSTFilterEdit }

  TDBVSTFilterEdit = class(TEdit)
  public
    procedure Change(Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: char);
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { TDBVST }

  PDBTreeData = ^TStringList;

  TDBVST = class(TVirtualStringTree)
  private
    FDBFields: TStrings;
    FDBFieldsConvFrom: TStrings;
    FDeep: Integer;
    FFieldsConvTo: TStrings;
    FFieldsDisp: TStrings;
    FLinkFields: TStrings;
    FMasterControls: TStrings;
    FKey: String;
    FConnection: TSQLConnection;
    FOrder: String;
    FSQL: TStrings;
    FTable: String;
    FWhere: String;
    FilterEdit: TDBVSTFilterEdit;
    FocusedSave: String;
    procedure SetConnection(AValue: TSQLConnection);
    procedure SetDBFields(AValue: TStrings);
    procedure SetDBFieldsConvFrom(AValue: TStrings);
    procedure SetDeep(AValue: Integer);
    procedure SetFieldsConvTo(AValue: TStrings);
    procedure SetFieldsDisp(AValue: TStrings);
    procedure SetKey(AValue: String);
    procedure SetLinkFields(AValue: TStrings);
    procedure SetMasterControls(AValue: TStrings);
    procedure SetOrder(AValue: String);
    procedure SetSQL(AValue: TStrings);
    procedure SetTable(AValue: String);
    procedure SetWhere(AValue: String);
    function GetSQLFieldStringFrom(i: Integer):String;
    function GetSQLFieldStringTo(aVal: String; i: Integer):String;
    procedure SetFocusById(newId:String);
  protected
    procedure GetNodeDataSize(Sender: TBaseVirtualTree;
      var aNodeDataSize: Integer);
    procedure GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure FreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure InitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure NewText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; const NewText: String);
    procedure MakeSQL(forHeaders: Boolean);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure KeyPress(Sender: TObject; var Key: char);
    procedure FillNode(Node: PVirtualNode; levFull:integer; fReplace:Boolean);
    procedure FillNode(Node: PVirtualNode);
    procedure SeekId(aID: String);
    procedure AddFromQuery(aQuery: String);
    procedure DelFromWhere(aQuery: String);
    procedure ReFill();
    procedure ReFill(aID: String);
    procedure Init();
    procedure Edited(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure Expanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ColumnDblClick(
      Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
    procedure CreateEditor(Sender: TBaseVirtualTree;
       Node: PVirtualNode; Column: TColumnIndex; out aEditLink: IVTEditLink);
    procedure FocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    function GetSelectedID(): String;
    function GetID(Node: PVirtualNode): String;
    function GetDBVST(aName: String): TDBVST;
    function GetEditLinkProps(Node: PVirtualNode; Column: Integer): TStrings;
    function GetSQLSelectedID(SQLStringQuote: String): String;
    function GetSQLSelectedIDs(SQLStringQuote, SQLFieldDelimiter: String): String;
  published
    property SQL: TStrings read FSQL write SetSQL;
    property DBTable: String read FTable write SetTable;
    property DBFields: TStrings read FDBFields write SetDBFields;
    property DBFieldsDisp: TStrings read FFieldsDisp write SetFieldsDisp;
    property DBFieldsConvTo: TStrings read FFieldsConvTo write SetFieldsConvTo;
    property DBFieldsConvFrom: TStrings read FDBFieldsConvFrom write SetDBFieldsConvFrom;
    property DBMasterControls: TStrings read FMasterControls write SetMasterControls;
    property DBLinkFields: TStrings read FLinkFields write SetLinkFields;
    property Deep: Integer read FDeep write SetDeep;
    property Key: String read FKey write SetKey;
    property Order: String read FOrder write SetOrder;
    property Where: String read FWhere write SetWhere;
    property Connection: TSQLConnection read FConnection write SetConnection;
 end;

  function FieldStringFrom(aField, aConvFrom: String):String;
  function FieldStringTo(aVal, aConvTo: String):String;
  function SQLQuote(aVal: String):String;
  procedure Register;

implementation

const
     WrapWidth: Integer = 80;
     SearchDelimiter: String = ' ';
     sqlStringQuote = '$$';
     sqlFieldDelimiter = ',';

function FieldStringFrom(aField, aConvFrom: String): String;
begin
  if length(aConvFrom) > 0 then
    Result := aField+'::'+ aConvFrom
  else
    Result := aField;
end;

function FieldStringTo(aVal, aConvTo: String): String;
begin
  if length(aConvTo) > 0 then
    Result := aVal+'::'+ aConvTo
  else
    Result := aVal;
end;

function SQLQuote(aVal: String): String;
begin
  if length(aVal) > 0 then
    Result:=sqlStringQuote+aVal+sqlStringQuote
  else
    Result:='NULL';
end;

procedure Register;
begin
  RegisterComponents('Virtual Controls',[TDBVST, TDBVMemo, TDBVCombo, TDBVEdit]);
end;

{ TDBVCombo }

procedure TDBVCombo.SetConnection(AValue: TPQConnection);
begin
  if FConnection=AValue then Exit;
  FConnection:=aValue;
end;

procedure TDBVCombo.SetDBField(AValue: String);
begin
  if FDBField=AValue then Exit;
  FDBField:=AValue;
end;

procedure TDBVCombo.SetDBFieldConvFrom(AValue: String);
begin
  if FDBFieldConvFrom=AValue then Exit;
  FDBFieldConvFrom:=AValue;
end;

procedure TDBVCombo.SetDBFieldConvTo(AValue: String);
begin
  if FDBFieldConvTo=AValue then Exit;
  FDBFieldConvTo:=AValue;
end;

procedure TDBVCombo.SetDBTable(AValue: String);
begin
  if FDBTable=AValue then Exit;
  FDBTable:=AValue;
end;

procedure TDBVCombo.SetLinkFields(AValue: TStrings);
begin
  if FLinkFields=AValue then Exit;
  if AValue<>nil then
    FLinkFields.Assign(AValue);
end;

procedure TDBVCombo.SetMasterControls(AValue: TStrings);
begin
  if FMasterControls=AValue then Exit;
  if AValue<>nil then
    FMasterControls.Assign(AValue);
end;

procedure TDBVCombo.SetWhere(AValue: String);
begin
  if FWhere=AValue then Exit;
  FWhere:=AValue;
end;

procedure TDBVCombo.OnExitExecute(Sender: TObject);
begin
  if not (FText = Text) then
    Save;
end;

procedure TDBVCombo.ReFill;
var
  xQuery: TExtSQLQuery;
  ParentVST: TDBVST;
  i: Integer;
begin
  Clear;
  try
    xQuery := TExtSQLQuery.Create(Self, FConnection);
    xQuery.SQL.Add(' select distinct ' + FieldStringFrom(DBField, DBFieldConvFrom));
    xQuery.SQL.Add(' from ' + DBTable);
    xQuery.SQL.Add(' where true ');
    for i:=0 to FMasterControls.Count-1 do begin
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      if ParentVST.SelectedCount < 1 then break;
      xQuery.SQL.Add(' and ' + FLinkFields[i] + ' in ('
        + ParentVST.GetSQLSelectedIDs('$$', ',') + ') ');
    end;
//    xQuery.SQL.Add(' group by ' + DBField);
// writeln(xQuery.SQL.Text);
    xQuery.Open;
    while not xQuery.Eof do begin
      if Self.Text > '' then Self.Text:=Self.Text+', ';
      Self.Text:=Self.Text+(xQuery.Fields[0].AsString);
      xQuery.Next;
    end;
    FText:=Self.Text;
  finally
    xQuery.Free;
  end;
end;

procedure TDBVCombo.Save;
var
  xQuery: TExtSQLQuery;
  ParentVST: TDBVST;
  i: Integer;
begin
  try
    xQuery := TExtSQLQuery.Create(Self, FConnection);
    xQuery.SQL.Add(' update ' + DBTable);
    xQuery.SQL.Add(' set ' + DBField + '='
      + FieldStringTo(SQLQuote(trim(Text)), DBFieldConvTo));
    xQuery.SQL.Add(' where true ');
    for i:=0 to FMasterControls.Count-1 do begin
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      xQuery.SQL.Add(' and ' + FLinkFields[i] + ' in ('
        + ParentVST.GetSQLSelectedIDs('$$', ',') + ') ');
    end;
    xQuery.ExecSQL;
  finally
    xQuery.Free;
  end;
end;

constructor TDBVCombo.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FConnection:=TPQConnection.Create(Self);
  FConnection.SetSubComponent(true);
  FLinkFields:=TStringList.Create();
  FMasterControls:=TStringList.Create();
  OnExit:=@OnExitExecute;
end;

destructor TDBVCombo.Destroy;
begin
  FLinkFields.Free;
  FLinkFields:=nil;
  FMasterControls.Free;
  FMasterControls:=nil;
  inherited Destroy;
end;


{ TDBVMemo }

procedure TDBVMemo.SetConnection(AValue: TPQConnection);
begin
  if FConnection=AValue then Exit;
  FConnection:=aValue;
end;

procedure TDBVMemo.SetDBField(AValue: String);
begin
  if FDBField=AValue then Exit;
  FDBField:=AValue;
end;

procedure TDBVMemo.SetDBFieldConvFrom(AValue: String);
begin
  if FDBFieldConvFrom=AValue then Exit;
  FDBFieldConvFrom:=AValue;
end;

procedure TDBVMemo.SetDBFieldConvTo(AValue: String);
begin
  if FDBFieldConvTo=AValue then Exit;
  FDBFieldConvTo:=AValue;
end;

procedure TDBVMemo.SetDBTable(AValue: String);
begin
  if FDBTable=AValue then Exit;
  FDBTable:=AValue;
end;

procedure TDBVMemo.SetLinkFields(AValue: TStrings);
begin
  if FLinkFields=AValue then Exit;
  if AValue<>nil then
    FLinkFields.Assign(AValue);
end;

procedure TDBVMemo.SetMasterControls(AValue: TStrings);
begin
  if FMasterControls=AValue then Exit;
  if AValue<>nil then
    FMasterControls.Assign(AValue);
end;

procedure TDBVMemo.SetWhere(AValue: String);
begin
  if FWhere=AValue then Exit;
  FWhere:=AValue;
end;

procedure TDBVMemo.OnExitExecute(Sender: TObject);
begin
  if not (FText = Text) then
    Save;
end;

procedure TDBVMemo.ReFill;
var
  xQuery: TExtSQLQuery;
  ParentVST: TDBVST;
  i: Integer;
begin
  Clear;
  try
    xQuery := TExtSQLQuery.Create(Self, FConnection);
    xQuery.SQL.Add(' select ' + FieldStringFrom(DBField, DBFieldConvFrom));
    xQuery.SQL.Add(' from ' + DBTable);
    xQuery.SQL.Add(' where true ');
    for i:=0 to FMasterControls.Count-1 do begin
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      if ParentVST.SelectedCount < 1 then break;
      xQuery.SQL.Add(' and ' + FLinkFields[i] + ' in ('
        + ParentVST.GetSQLSelectedIDs('$$', ',') + ') ');
    end;
//    xQuery.SQL.Add(' group by ' + DBField);
    xQuery.Open;
    while not xQuery.Eof do begin
      Self.Append(xQuery.Fields[0].AsString);
      xQuery.Next;
    end;
    FText:=Text;
  finally
    xQuery.Free;
  end;
end;

procedure TDBVMemo.Save;
var
  xQuery: TExtSQLQuery;
  ParentVST: TDBVST;
  i: Integer;
begin
  try
    xQuery := TExtSQLQuery.Create(Self, FConnection);
    xQuery.SQL.Add(' update ' + DBTable);
    xQuery.SQL.Add(' set ' + DBField + '='
      + FieldStringTo(SQLQuote(trim(Text)), DBFieldConvTo));
    xQuery.SQL.Add(' where true ');
    for i:=0 to FMasterControls.Count-1 do begin
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      xQuery.SQL.Add(' and ' + FLinkFields[i] + ' in ('
        + ParentVST.GetSQLSelectedIDs('$$', ',') + ') ');
    end;
    xQuery.ExecSQL;
  finally
    xQuery.Free;
  end;
end;

constructor TDBVMemo.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FConnection:=TPQConnection.Create(Self);
  FConnection.SetSubComponent(true);
  FLinkFields:=TStringList.Create();
  FMasterControls:=TStringList.Create();
  OnExit:=@OnExitExecute;
end;

destructor TDBVMemo.Destroy;
begin
  FLinkFields.Free;
  FLinkFields:=nil;
  FMasterControls.Free;
  FMasterControls:=nil;
  inherited Destroy;
end;


{ TDBVEdit }

procedure TDBVEdit.SetConnection(AValue: TPQConnection);
begin
  if FConnection=AValue then Exit;
  FConnection:=aValue;
end;

procedure TDBVEdit.SetDBField(AValue: String);
begin
  if FDBField=AValue then Exit;
  FDBField:=AValue;
end;

procedure TDBVEdit.SetDBFieldConvFrom(AValue: String);
begin
  if FDBFieldConvFrom=AValue then Exit;
  FDBFieldConvFrom:=AValue;
end;

procedure TDBVEdit.SetDBFieldConvTo(AValue: String);
begin
  if FDBFieldConvTo=AValue then Exit;
  FDBFieldConvTo:=AValue;
end;

procedure TDBVEdit.SetDBTable(AValue: String);
begin
  if FDBTable=AValue then Exit;
  FDBTable:=AValue;
end;

procedure TDBVEdit.SetLinkFields(AValue: TStrings);
begin
  if FLinkFields=AValue then Exit;
  if AValue<>nil then
    FLinkFields.Assign(AValue);
end;

procedure TDBVEdit.SetMasterControls(AValue: TStrings);
begin
  if FMasterControls=AValue then Exit;
  if AValue<>nil then
    FMasterControls.Assign(AValue);
end;

procedure TDBVEdit.SetWhere(AValue: String);
begin
  if FWhere=AValue then Exit;
  FWhere:=AValue;
end;

procedure TDBVEdit.OnExitExecute(Sender: TObject);
begin
  if not (FText = Text) then
    Save;
end;

procedure TDBVEdit.ReFill;
var
  xQuery: TExtSQLQuery;
  ParentVST: TDBVST;
  i: Integer;
begin
  Clear;
  try
    xQuery := TExtSQLQuery.Create(Self, FConnection);
    xQuery.SQL.Add(' select distinct ' + FieldStringFrom(DBField, DBFieldConvFrom));
    xQuery.SQL.Add(' from ' + DBTable);
    xQuery.SQL.Add(' where true ');
    for i:=0 to FMasterControls.Count-1 do begin
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      if ParentVST.SelectedCount < 1 then break;
      xQuery.SQL.Add(' and ' + FLinkFields[i] + ' in ('
        + ParentVST.GetSQLSelectedIDs('$$', ',') + ') ');
    end;
//    xQuery.SQL.Add(' group by ' + DBField);
// writeln(xQuery.SQL.Text);
    xQuery.Open;
    while not xQuery.Eof do begin
      if Self.Text > '' then Self.Text:=Self.Text+', ';
      Self.Text:=Self.Text+(xQuery.Fields[0].AsString);
      xQuery.Next;
    end;
    FText:=Self.Text;
  finally
    xQuery.Free;
  end;
end;

procedure TDBVEdit.Save;
var
  xQuery: TExtSQLQuery;
  ParentVST: TDBVST;
  i: Integer;
begin
  try
    xQuery := TExtSQLQuery.Create(Self, FConnection);
    xQuery.SQL.Add(' update ' + DBTable);
    xQuery.SQL.Add(' set ' + DBField + '='
      + FieldStringTo(SQLQuote(trim(Text)), DBFieldConvTo));
    xQuery.SQL.Add(' where true ');
    for i:=0 to FMasterControls.Count-1 do begin
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      xQuery.SQL.Add(' and ' + FLinkFields[i] + ' in ('
        + ParentVST.GetSQLSelectedIDs('$$', ',') + ') ');
    end;
    xQuery.ExecSQL;
  finally
    xQuery.Free;
  end;
end;

constructor TDBVEdit.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FConnection:=TPQConnection.Create(Self);
  FConnection.SetSubComponent(true);
  FLinkFields:=TStringList.Create();
  FMasterControls:=TStringList.Create();
  OnExit:=@OnExitExecute;
end;

destructor TDBVEdit.Destroy;
begin
  FLinkFields.Free;
  FLinkFields:=nil;
  FMasterControls.Free;
  FMasterControls:=nil;
  inherited Destroy;
end;


{ TDBVSTFilterEdit }

procedure TDBVSTFilterEdit.KeyPress(Sender: TObject; var Key: char);
begin
  if Key = char(27) then begin
    Text:='';
    Visible:=False;
    Application.MainForm.ActiveControl:=(Self.Owner as TWinControl);
  end;
end;

constructor TDBVSTFilterEdit.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  Parent:=(TheOwner as TWinControl);
  Visible:=False;
  Align:=alBottom;
  OnKeyPress:=@KeyPress;
  OnChange:=@Change;
end;

destructor TDBVSTFilterEdit.Destroy;
begin
  Self.Parent:=nil;
  inherited Destroy;
end;

procedure TDBVSTFilterEdit.Change(Sender: TObject);

  procedure SetVisibleParents(VSTNode: PVirtualNode);
  begin
    if not Assigned(VSTNode) then exit;
    VSTNode^.States:=VSTNode^.States + [vsExpanded, vsVisible];
    if VSTNode^.Index > 0 then
      SetVisibleParents(VSTNode^.Parent);
  end;

Var
  VSTNode: PVirtualNode;
  VSTNodeData: PDBTreeData;
  SearchList: TStringList;
  i, iCell: Integer;
  S: String;
  isFound, isCellFound: Boolean;
begin
  SearchList:=TStringList.Create;
  if not Owner.ClassNameIs('TDBVST') then exit;
  with (Owner as TDBVST) do begin
    If GetFirst = nil then Exit;
    VSTNode:=nil;
    S := FilterEdit.Text+SearchDelimiter;
    repeat
      i:=Pos(SearchDelimiter, S);
      if i>0 then begin
        if length(Copy(S, 0, i-1)) > 0 then
          SearchList.Add(Copy(S, 0, i-1));
        Delete(S,1,i);
      end;
    until i=0;
    Repeat
      isFound := False;
      if VSTNode = nil then VSTNode:=GetFirst Else VSTNode:=GetNext(VSTNode);
      VSTNodeData:=GetNodeData(VSTNode);
      VSTNode^.States:=VSTNode^.States - [vsSelected];
      for iCell:=1 to VSTNodeData^.Count-1 do begin
        isCellFound := True;
        for i:=0 to SearchList.Count-1 do
          isCellFound := isCellFound
            and (Pos(
               AnsilowerCase(SearchList[i]),
               AnsilowerCase(VSTNodeData^[iCell])
               ) > 0);
        isFound := isFound or isCellFound;
      end;
      If isFound then begin
        VSTNode^.States:=VSTNode^.States + [vsVisible];
        SetVisibleParents(VSTNode);
      end
      else
        VSTNode^.States:=VSTNode^.States - [vsVisible];
    Until VSTNode = GetLast();
    ClearSelection;
    OffsetY:=0;
    Refresh;
  end;
  SearchList.Free;
  SearchList:=nil;
  VSTNode:=nil;
  VSTNodeData:=nil;
end;



{ TDBVST }

procedure TDBVST.SetConnection(AValue: TSQLConnection);
begin
  if FConnection=AValue then Exit;
  FConnection:=AValue;
end;

procedure TDBVST.SetDBFields(AValue: TStrings);
begin
  if DBFields=AValue then Exit;
  if AValue<>nil then
    DBFields.Assign(AValue);
end;

procedure TDBVST.SetDBFieldsConvFrom(AValue: TStrings);
begin
  if DBFieldsConvFrom=AValue then Exit;
  if AValue<>nil then
    DBFieldsConvFrom.Assign(AValue);
end;

procedure TDBVST.SetDeep(AValue: Integer);
begin
  if FDeep=AValue then Exit;
  FDeep:=AValue;
end;

procedure TDBVST.SetFieldsConvTo(AValue: TStrings);
begin
  if FFieldsConvTo=AValue then Exit;
  FFieldsConvTo.Assign(AValue);
end;

procedure TDBVST.SetFieldsDisp(AValue: TStrings);
begin
  if FFieldsDisp=AValue then Exit;
  FFieldsDisp.Assign(AValue);
end;

procedure TDBVST.SetKey(AValue: String);
begin
  if FKey=AValue then Exit;
  FKey:=AValue;
end;

procedure TDBVST.SetLinkFields(AValue: TStrings);
begin
  if FLinkFields=AValue then Exit;
  FLinkFields.Assign(AValue);
end;

procedure TDBVST.SetMasterControls(AValue: TStrings);
begin
  if FMasterControls=AValue then Exit;
  FMasterControls.Assign(AValue);
end;

procedure TDBVST.SetOrder(AValue: String);
begin
  if FOrder=AValue then Exit;
  FOrder:=AValue;
end;

procedure TDBVST.SetSQL(AValue: TStrings);
begin
  if FSQL=AValue then Exit;
  FSQL:=AValue;
end;

procedure TDBVST.SetTable(AValue: String);
begin
  if FTable=AValue then Exit;
  FTable:=AValue;
end;

procedure TDBVST.SetWhere(AValue: String);
begin
  if AValue = '' then AValue := 'true';
  if FWhere=AValue then Exit;
  FWhere:=AValue;
end;

function TDBVST.GetSQLFieldStringFrom(i: Integer): String;
begin
  Result := FieldStringFrom(FDBFields[i], FDBFieldsConvFrom[i]);
end;

function TDBVST.GetSQLFieldStringTo(aVal: String; i: Integer): String;
begin
  Result := FieldStringTo(aVal, FFieldsConvTo[i]);
end;

procedure TDBVST.SetFocusById(newId: String);
Var
  XNode: PVirtualNode;
  Data: PDBTreeData;
begin
  If GetFirst = nil then Exit;
  XNode:=nil;
  Repeat
    if XNode = nil then XNode:=GetFirst Else XNode:=GetNext(XNode);
    Data:=GetNodeData(XNode);
    If (Data^[0] = newId) then
    Begin
      FocusedNode:=XNode;
      break;
    End;
  Until XNode = GetLast();
end;

procedure TDBVST.Edited(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
var
  i: Integer;
  MasterComponent: TComponent;
  aSql, FldList: TStringList;
  newId: String;
begin
  aSql:=TStringList.Create;
  FldList:=TStringList.Create;
  if GetSelectedID() = '' then begin
    aSql.Add('insert into ' + DBTable + ' (' + DBFields[Column+1]);
    if DBLinkFields.Count>0 then
      aSql.Add(', ' + ListToString(DBLinkFields,', ',''));
    aSql.Add(') ' + ' select '
      + FieldStringTo(SQLQuote(Text[Node, Column]),
        DBFieldsConvTo[Column+1]) );
    if DBLinkFields.Count>0 then
      aSql.Add(', ' + ListToString(DBLinkFields,', ',''));
    if DBLinkFields.Count>0 then begin
      aSql.Add(' from ');
      for i:=0 to DBLinkFields.Count-1 do begin
        if i>0 then aSql.Add(', ');
        aSql.Add(' unnest((array[');
        MasterComponent:=Owner.FindComponent(FMasterControls[i]);
        aSql.Add((MasterComponent as TDBVST).GetSQLSelectedIDs(sqlStringQuote, ',')
          + '])::uuid[]) ' + DBLinkFields[i]);
      end;
      aSql.Add(' returning ' + GetSQLFieldStringFrom(0));
    end;
    newId:=ReturnStringSQL(Connection, aSql.Text);
    if newId > '' then begin
      NewText(Self, Node, 0, newId);
      ReFill;
      SetFocusById(newId);
    end;
  end
  else begin
    aSql.Add('update ' + DBTable + ' set '
      + DBFields[Column+1]
      + ' = ' + FieldStringTo(SQLQuote(Text[Node, Column]),
        DBFieldsConvTo[Column+1]) + ' '
      + ' where ' + DBFields[0] + ' = ' + GetSQLFieldStringTo(GetSQLSelectedID(sqlStringQuote), 0));
    for i:=0 to DBLinkFields.Count-1 do begin
      MasterComponent:=Owner.FindComponent(FMasterControls[i]) ;
      aSql.Add(' and ' + DBLinkFields[i] + ' in ('
        + (MasterComponent as TDBVST).GetSQLSelectedIDs(sqlStringQuote, ',') + ') ');
    end;
    ExecSQL(Connection, aSql.Text);
  end;
end;

procedure TDBVST.Expanding(Sender: TBaseVirtualTree; Node: PVirtualNode;
  var Allowed: Boolean);
begin
  (Sender as TDBVST).FillNode(Node);
end;

procedure TDBVST.Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  Self.Refresh;
end;

procedure TDBVST.ColumnDblClick(Sender: TBaseVirtualTree; Column: TColumnIndex;
  Shift: TShiftState);
begin
  if not Assigned(Sender.FocusedNode) then exit;
  Sender.EditNode(Sender.FocusedNode, Column);
end;

procedure TDBVST.CreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; out aEditLink: IVTEditLink);
var
  xEditLinkProps: TStrings;
begin
  xEditLinkProps := GetEditLinkProps(Node, Column);
  if Assigned(xEditLinkProps) then
    aEditLink:=TCBStringEditLink.Create(Connection, xEditLinkProps)
  else
    aEditLink:=TStringEditLink.Create;
end;

procedure TDBVST.FocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
begin
  Self.Refresh;
end;

procedure TDBVST.GetNodeDataSize(Sender: TBaseVirtualTree;
  var aNodeDataSize: Integer);
begin
  aNodeDataSize := SizeOf(PDBTreeData^);
end;

procedure TDBVST.GetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PDBTreeData;
begin
  Data := GetNodeData(Node);
  CellText:=Data^[Column+1];
end;

procedure TDBVST.FreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PDBTreeData;
begin
  Data:=GetNodeData(Node);
  if Assigned(Data) then begin
    Data^.Free;
  end;
end;

procedure TDBVST.InitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node^.CheckType := ctTriStateCheckBox;
end;

procedure TDBVST.NewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; const NewText: String);
Var
  Data: PDBTreeData;
begin
  Data:=GetNodeData(Node);
  Data^[Column+1]:=NewText;
end;

procedure TDBVST.MakeSQL(forHeaders: Boolean);
var
  ParentVST: TDBVST;
  i: Integer;
begin
  FSQL.Clear;
  FSQL.Add('select count(*) __cnt, ');
  FSQL.Add(GetSQLFieldStringFrom(0));
  for i:=1 to FDBFields.Count-1 do begin
    FSQL.Add(', '+ GetSQLFieldStringFrom(i));
  end;
  FSQL.Add(' from ' + DBTable);
  if forHeaders then exit;
  if Where = '' then Where:='true';
  FSQL.Add(' where ' + Where);
  for i:=0 to DBMasterControls.Count-1 do begin
    try
      ParentVST:=(Owner.FindComponent(DBMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      FSQL.Add(' and (' + DBLinkFields[i] + ' in ('
      + ParentVST.GetSQLSelectedIDs('$$', ',') + ')) ');
    finally
    end;
  end;
//  FSQL.Add(' group by ' + ListToString(FDBFields,',',''));
end;

constructor TDBVST.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FConnection:=TSQLConnection.Create(Self);
  FConnection.SetSubComponent(true);
  FSQL:=TStringList.Create();
  FDBFields:=TStringList.Create();
  FFieldsDisp:=TStringList.Create();
  FFieldsConvTo:=TStringList.Create();
  FDBFieldsConvFrom:=TStringList.Create();
  FLinkFields:=TStringList.Create();
  FMasterControls:=TStringList.Create();
  FilterEdit:=TDBVSTFilterEdit.Create(Self);
  FKey:='null';
  OnEdited:=@Edited;
  OnExpanding:=@Expanding;
  OnColumnDblClick:=@ColumnDblClick;
  OnCreateEditor:=@CreateEditor;
  OnFocusChanged:=@FocusChanged;
  OnGetNodeDataSize:=@GetNodeDataSize;
  OnGetText:=@GetText;
  OnFreeNode:=@FreeNode;
  OnInitNode:=@InitNode;
  OnKeyPress:=@KeyPress;
  OnNewText:=@NewText;
  TreeOptions.MiscOptions:=TreeOptions.MiscOptions
    + [toEditable, toGridExtensions];
  TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions
    + [toExtendedFocus];
end;

destructor TDBVST.Destroy;
begin
  FilterEdit.Free;
  FilterEdit:=nil;
  FSQL.Free;
  FSQL:=nil;
  try
// Access violation is there !!!
    inherited;
  finally
  end;
end;

procedure TDBVST.KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key = char(27)) then begin
    Self.FilterEdit.Show;
    Application.MainForm.ActiveControl:=Self.FilterEdit;
  end;
end;

procedure TDBVST.FillNode(Node: PVirtualNode; levFull:integer; fReplace:Boolean = true);
var
  Query: TExtSQLQuery;
  NewNode : PVirtualNode;
  ParentNodeData: PDBTreeData;
  NodeData: TStringList;
  cnt, i: Integer;
begin
  if ((Node <> nil) and (Node^.ChildCount > 0)) and not fReplace then Exit;
  if ((Node = nil) and Assigned(GetFirst())) then Exit;
  Cursor:=crSQLWait;
//  Application.ProcessMessages;
  try
    Query := TExtSQLQuery.Create(Self, FConnection);
    Query.SQL.Text := FSQL.Text;
    if fReplace then
       Query.SQL.Add(' and ' + GetSQLFieldStringFrom(0)
         + ' = ' + GetID(Node));
    if (Node = nil) then
       Query.SQL.Add(' ' + ' and '
       + FKey + ' is null ')
    else begin
      ParentNodeData:=Self.GetNodeData(Node);
      Query.SQL.Add(' ' + ' and '
       + FKey + ' = $$' + ParentNodeData^[0] + '$$ ');
    end;
    Query.SQL.Add(' group by ' + ListToString(FDBFields,',','')
      + ' order by ' + FOrder);
//writeln(Query.SQL.Text);
    Query.Open;
    while not Query.Eof do
    begin
      NodeData:=TStringList.Create;
      NodeData.Add(Query.Fields[1].AsString);
      if Query.Fields[0].AsInteger > 1 then
         NodeData.Add('[' + Query.Fields[0].AsString + '] '
           + Query.Fields[2].AsString)
      else
        NodeData.Add(Query.Fields[2].AsString);
      cnt := 3;
      for i:=cnt to Query.FieldCount-1 do begin
        NodeData.Add(Query.Fields[i].AsString);
      end;
      NewNode:=Self.InsertNode(Node, amAddChildLast, NodeData);
      if not(levFull = 0) then FillNode(NewNode, levFull - 1, fReplace);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TDBVST.FillNode(Node: PVirtualNode);
begin
  FillNode(Node, 1, false)
end;

procedure TDBVST.SeekId(aID: String);
Var
  VSTNode: PVirtualNode;
begin
  If GetFirst = nil then Exit;
  VSTNode:=nil;
  Repeat
    if VSTNode = nil then VSTNode:=GetFirst Else VSTNode:=GetNext(VSTNode);
    if GetID(VSTNode) = aID then begin
      Self.FocusedNode:=VSTNode;
      Self.Selected[VSTNode]:=True;
      Refresh;
      exit;
    end;
  until VSTNode=GetLast();
end;

procedure TDBVST.AddFromQuery(aQuery: String);
var
  xSQL: String;
  i: Integer;
begin
  xSQL := 'insert into ' + FTable + '('
    + FDBFields[0] + ','
    + ListToString(DBLinkFields,',','')
    + ') '
    + aQuery;
  ExecSQL(Connection, xSQL);
  ReFill;
end;

procedure TDBVST.DelFromWhere(aQuery: String);
var
  xSQL: String;
  i: Integer;
begin
  xSQL := 'delete from ' + FTable
    + ' where ' + aQuery;
  ExecSQL(Connection, xSQL);
  ReFill;
end;


procedure TDBVST.ReFill;
var
  isSelected: Boolean;
  i: Integer;
  ParentVST: TDBVST;
begin
  if GetSelectedID > '' then
     FocusedSave:=GetSelectedID;
  Clear;
  if not Connection.Connected then exit;
  isSelected:=True;
  for i:=0 to DBMasterControls.Count-1 do begin
    ParentVST:=GetDBVST(DBMasterControls[i]);
    if not Assigned(ParentVST) then begin
      isSelected:=False;
      break;
    end;
    if ParentVST.SelectedCount = 0 then begin
      isSelected:=False;
      break;
    end;
  end;
  if isSelected then begin
    MakeSQL(false);
    FillNode(nil, Deep, false);
  end;
  FocusedNode:=nil;
  SeekID(FocusedSave);
end;

procedure TDBVST.ReFill(aID: String);
Var
  XNode: PVirtualNode;
  Data: PDBTreeData;
begin
  if length(aID) = 0 then exit;
  If GetFirst = nil then Exit;
  XNode:=nil;
  Repeat
    if XNode = nil then XNode:=GetFirst Else XNode:=GetNext(XNode);
    Data:=GetNodeData(XNode);
    If (Data^[0] = aID) then
    Begin
      FillNode(XNode,0,true);
      break;
    End;
  Until XNode = GetLast();
end;

procedure TDBVST.Init;
var
  i: Integer;
  Column: TVirtualTreeColumn;
begin
  Clear;
  if not Connection.Connected then exit;
  for i:=Header.Columns.Count+1 to DBFields.Count-1 do begin
    Column:=Header.Columns.Add;
    Column.Width:=200;
    Column.Options:=Column.Options + [coAllowClick, coAllowFocus];
    Column.Text:=DBFieldsDisp[i];
  end;
  Header.Options:=Header.Options + [hoVisible, hoAutoResize];
  TreeOptions.MiscOptions:=TreeOptions.MiscOptions
    + [toEditable, toGridExtensions];
  TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions
    + [toExtendedFocus];
  ReFill;
end;

function TDBVST.GetSelectedID: String;
begin
  Result := GetID(FocusedNode);
end;

function TDBVST.GetSQLSelectedID(SQLStringQuote: String): String;
begin
  Result := SQLStringQuote + GetID(FocusedNode) + SQLStringQuote;
end;


function TDBVST.GetSQLSelectedIDs(SQLStringQuote, SQLFieldDelimiter: String): String;
var
  res: String;
  i: Integer;
  Node: PVirtualNode;
begin
  res := '';
  Result:= SQLStringQuote+SQLStringQuote;
  Node:=GetFirstSelected();
  while Assigned(Node) do begin
    if length(res) > 0 then res := res + SQLFieldDelimiter ;
    res := res + SQLStringQuote
      + GetID(Node)
      + SQLStringQuote;
    Node:=GetNextSelected(Node);
  end;
  if res = '' then res:= SQLStringQuote + SQLStringQuote;
  Result := res;
end;

function TDBVST.GetID(Node: PVirtualNode): String;
var
  VSTNodeData: PDBTreeData;
begin
  if Assigned(Node) then begin
    VSTNodeData := GetNodeData(Node);
    Result := VSTNodeData^[0];
  end
  else
    Result := '';
end;

function TDBVST.GetDBVST(aName: String): TDBVST;
var
  ParentVST: TDBVST;
begin
  try
    ParentVST:=(Owner.FindComponent(aName) as TDBVST);
    Result:=ParentVST;
  except
      Result:=nil;
  end;
end;

function TDBVST.GetEditLinkProps(Node: PVirtualNode; Column: Integer): TStrings;
var
  xList: TStrings;
  xText: String;
begin
  Result:=nil;
  GetText(Self, Node, 0, ttStatic, xText);
  if (Column=1)
      and ((Copy(xText, 0, 2) = 'Р.') or (Copy(xText, 0, 2) = 'P.')) then begin
    xList:=TStringList.Create;
    xList.Add('select disp from positions order by 1');
    Result:=xList;
  end;
end;

end.
