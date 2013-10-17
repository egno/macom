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
  sqldb, extsqlquery, db, dbfunc,
  VirtualTrees;

type

  { TDBVST }

  PDBTreeData = ^TStringList;

  { TDBVSTFilterEdit }

  TDBVSTFilterEdit = class(TEdit)
  public
    procedure Change(Sender: TObject);
    procedure KeyPress(Sender: TObject; var Key: char);
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

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
    procedure Edited(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure Expanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ColumnDblClick(
      Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
    procedure FocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
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
    procedure FillNode(Node: PVirtualNode; levFull:integer);
    procedure FillNode(Node: PVirtualNode);
    procedure AddFromQuery(aQuery: String);
    procedure DelFromWhere(aQuery: String);
    procedure ReFill();
    procedure Init();
    function GetSelectedID(): String;
    function GetID(Node: PVirtualNode): String;
    function GetDBVST(aName: String): TDBVST;
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

procedure Register;

implementation

const
     WrapWidth: Integer = 80;
     SearchDelimiter: String = ' ';

procedure Register;
begin
  RegisterComponents('Virtual Controls',[TDBVST]);
end;

procedure TDBVSTFilterEdit.KeyPress(Sender: TObject; var Key: char);
begin
  if Key = char(27) then begin
    Text:='';
    Application.MainForm.ActiveControl:=(Parent as TWinControl);
    Visible:=False;
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
  inherited Destroy;
end;

procedure TDBVSTFilterEdit.Change(Sender: TObject);

  procedure SetVisibleParents(VSTNode: PVirtualNode);
  begin
    if Assigned(VSTNode^.Parent) then begin
      VSTNode^.Parent^.States:=VSTNode^.Parent^.States + [vsExpanded, vsVisible];
      SetVisibleParents(VSTNode^.Parent);
    end;
  end;

Var
  VSTNode: PVirtualNode;
  VSTNodeData: PDBTreeData;
  SearchList: TStringList;
  i: Integer;
  S: String;
  isFound: Boolean;
begin
  with (Owner as TDBVST) do begin
    If GetFirst = nil then Exit;
    VSTNode:=nil;
    SearchList:=TStringList.Create;
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
      isFound := True;
      if VSTNode = nil then VSTNode:=GetFirst Else VSTNode:=GetNext(VSTNode);
      VSTNodeData:=GetNodeData(VSTNode);
      VSTNode^.States:=VSTNode^.States - [vsSelected];
      for i:=0 to SearchList.Count-1 do
        isFound := isFound and (Pos(SearchList[i],VSTNodeData^[1]) > 0);
      If isFound then begin
        VSTNode^.States:=VSTNode^.States + [vsVisible];
        SetVisibleParents(VSTNode);
      end
      else
        VSTNode^.States:=VSTNode^.States - [vsVisible];
    Until VSTNode = GetLast();
    Refresh;
    SearchList.Free;
  end;
end;


{ TDBVSTFilterEdit }

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
  FSQL.Assign(AValue);
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
var
  res: String;
begin
  res:=FDBFields[i];
  if FDBFieldsConvFrom[i] > '' then
    res := res+'::'+ FDBFieldsConvFrom[i];
  Result := res;
end;

function TDBVST.GetSQLFieldStringTo(aVal: String; i: Integer): String;
var
  res: String;
begin
  res:=aVal;
  if FFieldsConvTo[i] > '' then
    res := res+'::'+ FFieldsConvTo[i];
  Result := res;
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
const
  sqlStringQuote: String = '$$';
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
      + sqlStringQuote + Text[Node, Column] + sqlStringQuote);
    if DBLinkFields.Count>0 then
      aSql.Add(', ' + ListToString(DBLinkFields,', ',''));
    if DBLinkFields.Count>0 then begin
      aSql.Add(' from ');
      for i:=0 to DBLinkFields.Count-1 do begin
        if i>0 then aSql.Add(', ');
        aSql.Add(' unnest(array[');
        MasterComponent:=Owner.FindComponent(FMasterControls[i]);
        aSql.Add((MasterComponent as TDBVST).GetSQLSelectedIDs(sqlStringQuote, ',')
          + ']) ' + DBLinkFields[i]);
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
      + ' = ' + sqlStringQuote + Text[Node, Column] + sqlStringQuote + ' '
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
  OnFocusChanged:=@FocusChanged;
  OnGetNodeDataSize:=@GetNodeDataSize;
  OnGetText:=@GetText;
  OnFreeNode:=@FreeNode;
  OnInitNode:=@InitNode;
  OnKeyPress:=@KeyPress;
  OnNewText:=@NewText;
end;

destructor TDBVST.Destroy;
begin
  inherited Destroy;
end;

procedure TDBVST.KeyPress(Sender: TObject; var Key: char);
begin
  if (Key = char(27)) then begin
    FilterEdit.Text:='';
    FilterEdit.Visible:=False;
    exit;
  end;
  if not FilterEdit.Visible then begin
    FilterEdit.Visible:=True;
    Application.MainForm.ActiveControl:=FilterEdit;
  end;
end;

procedure TDBVST.FillNode(Node: PVirtualNode; levFull:integer);
var
  Query: TExtSQLQuery;
  NewNode : PVirtualNode;
  ParentNodeData: PDBTreeData;
  NodeData: TStringList;
  cnt, i: Integer;
begin
  if (Node <> nil) and (Node^.ChildCount > 0) then Exit;
  Cursor:=crSQLWait;
//  Application.ProcessMessages;
  try
    Query := TExtSQLQuery.Create(Self, FConnection);
    if (Node = nil) then
       Query.SQL.Text := FSQL.Text + ' ' + ' and '
       + FKey + ' is null '
       + ' group by ' + ListToString(FDBFields,',','')
       + ' order by ' + FOrder
    else begin
      ParentNodeData:=Self.GetNodeData(Node);
      Query.SQL.Text := FSQL.Text + ' ' + ' and '
       + FKey + ' = $$' + ParentNodeData^[0] + '$$ '
       + ' group by ' + ListToString(FDBFields,',','')
       + ' order by ' + FOrder;
    end;
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
      if not(levFull = 0) then FillNode(NewNode, levFull - 1);
      Query.Next;
    end;
  finally
    Query.Free;
  end;
end;

procedure TDBVST.FillNode(Node: PVirtualNode);
begin
  FillNode(Node, 1)
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
    FillNode(nil, Deep);
  end;
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


end.
