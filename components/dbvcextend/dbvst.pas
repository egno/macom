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
  sqldb, extsqlquery, db,
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
    FFields: TStringList;
    FFieldsConvFrom: TStringList;
    FFieldsConvTo: TStringList;
    FFieldsDisp: TStringList;
    FKey: String;
    FConnection: TSQLConnection;
    FLinkFields: TStringList;
    FMasterControls: TStringList;
    FOrder: String;
    FSQL: TStringList;
    FTable: String;
    FWhere: String;
    FilterEdit: TDBVSTFilterEdit;
    procedure SetConnection(AValue: TSQLConnection);
    procedure SetFields(AValue: TStringList);
    procedure SetFieldsConvFrom(AValue: TStringList);
    procedure SetFieldsConvTo(AValue: TStringList);
    procedure SetFieldsDisp(AValue: TStringList);
    procedure SetKey(AValue: String);
    procedure SetLinkFields(AValue: TStringList);
    procedure SetMasterControls(AValue: TStringList);
    procedure SetOrder(AValue: String);
    procedure SetSQL(AValue: TStringList);
    procedure SetTable(AValue: String);
    procedure SetWhere(AValue: String);
  protected
    procedure Edited(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure Expanding(Sender: TBaseVirtualTree;
      Node: PVirtualNode; var Allowed: Boolean);
    procedure Change(Sender: TBaseVirtualTree; Node: PVirtualNode);
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
    procedure AddFrom(Src: TDBVST);
    procedure ReFill(levFull: integer);
    procedure InitAndFill(conn: TSQLConnection; aTable:String;
      aFields, aFieldsDisp, aFieldsConvTo, aFieldsConvFrom,
      aMasterControls, aLinkFielsd:array of String;
      aKey, aWhere, aOrder: String; levFull:integer);
    function GetSelectedID(): String;
    function GetID(Node: PVirtualNode): String;
    function GetDBVST(aName: String): TDBVST;
    function GetSQLSelectedID(SQLStringQuote: String): String;
    function GetSQLSelectedIDs(SQLStringQuote, SQLFieldDelimiter: String): String;
    function SaveAll():String;
    function SaveRow():String;
  published
    property SQL: TStringList read FSQL write SetSQL;
    property Table: String read FTable write SetTable;
    property Fields: TStringList read FFields write SetFields;
    property FieldsDisp: TStringList read FFieldsDisp write SetFieldsDisp;
    property FieldsConvTo: TStringList read FFieldsConvTo write SetFieldsConvTo;
    property FieldsConvFrom: TStringList read FFieldsConvFrom write SetFieldsConvFrom;
    property MasterControls: TStringList read FMasterControls write SetMasterControls;
    property LinkFields: TStringList read FLinkFields write SetLinkFields;
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
    Application.MainForm.ActiveControl:=(Owner as TWinControl);
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

procedure TDBVST.SetFields(AValue: TStringList);
begin
  if FFields=AValue then Exit;
  FFields:=AValue;
end;

procedure TDBVST.SetFieldsConvFrom(AValue: TStringList);
begin
  if FFieldsConvFrom=AValue then Exit;
  FFieldsConvFrom:=AValue;
end;

procedure TDBVST.SetFieldsConvTo(AValue: TStringList);
begin
  if FFieldsConvTo=AValue then Exit;
  FFieldsConvTo:=AValue;
end;

procedure TDBVST.SetFieldsDisp(AValue: TStringList);
begin
  if FFieldsDisp=AValue then Exit;
  FFieldsDisp:=AValue;
end;

procedure TDBVST.SetKey(AValue: String);
begin
  if FKey=AValue then Exit;
  FKey:=AValue;
end;

procedure TDBVST.SetLinkFields(AValue: TStringList);
begin
  if FLinkFields=AValue then Exit;
  FLinkFields:=AValue;
end;

procedure TDBVST.SetMasterControls(AValue: TStringList);
begin
  if FMasterControls=AValue then Exit;
  FMasterControls:=AValue;
end;

procedure TDBVST.SetOrder(AValue: String);
begin
  if FOrder=AValue then Exit;
  FOrder:=AValue;
end;

procedure TDBVST.SetSQL(AValue: TStringList);
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

procedure TDBVST.Edited(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
begin
  SaveRow();
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

  function GetSQLFieldString(i: Integer):String;
  var
    res: String;
  begin
    res:=FFields[i];
    if FFieldsConvFrom[i] > '' then
      res := res+'::'+ FFieldsConvFrom[i];
    Result := res;
  end;

var
  ParentVST: TDBVST;
  i: Integer;
begin
  FSQL.Clear;
  FSQL.Add('select ');
  FSQL.Add(GetSQLFieldString(0));
  for i:=1 to FFields.Count-1 do begin
    FSQL.Add(', '+ GetSQLFieldString(i));
  end;
  FSQL.Add(' from ' + Table);
  if forHeaders then exit;
  FSQL.Add(' where ' + Where);
  for i:=0 to FMasterControls.Count-1 do begin
    try
      ParentVST:=(Owner.FindComponent(FMasterControls[i]) as TDBVST);
      if ParentVST = nil then break;
      FSQL.Add(' and (' + FLinkFields[i] + ' in ('
      + ParentVST.GetSQLSelectedIDs('$$', ',') + ')) ');
    finally
    end;
  end;
end;

constructor TDBVST.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FConnection:=TSQLConnection.Create(Self);
  FConnection.SetSubComponent(true);
  FSQL:=TStringList.Create();
  FFields:=TStringList.Create();
  FFieldsDisp:=TStringList.Create();
  FFieldsConvTo:=TStringList.Create();
  FFieldsConvFrom:=TStringList.Create();
  FLinkFields:=TStringList.Create();
  FMasterControls:=TStringList.Create();
  OnExpanding:=@Expanding;
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
  if not Assigned(FilterEdit) then begin
    FilterEdit:=TDBVSTFilterEdit.Create(Self);
    Refresh;
  end;
  if not FilterEdit.Visible then begin
    FilterEdit.Visible:=True;
    Application.MainForm.ActiveControl:=FilterEdit;
  end
  else
    if Key = char(27) then begin
      FilterEdit.Text:='';
      FilterEdit.Visible:=False;
    end;

end;

procedure TDBVST.FillNode(Node: PVirtualNode; levFull:integer);
var
  Query: TExtSQLQuery;
  NewNode : PVirtualNode;
  ParentNodeData: PDBTreeData;
  NodeData: TStringList;
  cnt, i: Integer;
  Checked, hasChecked, hasUnchecked: Boolean;
begin
  if (Node <> nil) and (Node^.ChildCount > 0) then Exit;
  Cursor:=crSQLWait;
//  Application.ProcessMessages;
  try
    Query := TExtSQLQuery.Create(Self, FConnection);
    if (Node = nil) then
       Query.SQL.Text := FSQL.Text + ' ' + ' and '
       + FKey + ' is null order by ' + FOrder
    else begin
      ParentNodeData:=Self.GetNodeData(Node);
      Query.SQL.Text := FSQL.Text + ' ' + ' and '
       + FKey + ' = ''' + ParentNodeData^[0] + ''' order by ' + FOrder;
    end;
    Checked:=false;
    hasChecked := false;
    hasUnchecked := false;
    Query.Open;
    while not Query.Eof do
    begin
      NodeData:=TStringList.Create;
      NodeData.Add(Query.Fields[0].AsString);
      cnt := 1;
      for i:=cnt to Query.FieldCount-1 do begin
        NodeData.Add(Query.Fields[i].AsString);
      end;
      NewNode:=Self.InsertNode(Node, amAddChildLast, NodeData);
      if Checked then
        NewNode^.CheckState := csCheckedNormal
      else
        NewNode^.CheckState := csUncheckedNormal;
      if not(levFull = 0) then FillNode(NewNode, levFull - 1);
      Query.Next;
    end;
    if Assigned(Node) then begin
      if hasChecked then
         if hasUnchecked then Node^.CheckState:=csMixedNormal
         else Node^.CheckState:=csCheckedNormal
      else Node^.CheckState:=csUncheckedNormal
    end;

  finally
    Query.Free;
  end;
end;

procedure TDBVST.FillNode(Node: PVirtualNode);
begin
  FillNode(Node, 1)
end;

procedure TDBVST.AddFrom(Src: TDBVST);
begin
{  sql:= 'insert into ' + FTable
    + ' ( ' +
}
end;

procedure TDBVST.ReFill(levFull: integer);
var
  isSelected: Boolean;
  i: Integer;
  ParentVST: TDBVST;
begin
  Clear;
  isSelected:=True;
  for i:=0 to FMasterControls.Count-1 do begin
    ParentVST:=GetDBVST(FMasterControls[i]);
    writeln(ParentVST.Name);
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
    FillNode(nil, levFull);
  end;
end;

procedure TDBVST.InitAndFill(conn: TSQLConnection; aTable: String; aFields,
  aFieldsDisp, aFieldsConvTo, aFieldsConvFrom, aMasterControls,
  aLinkFielsd: array of String; aKey, aWhere, aOrder: String; levFull: integer);

var
  Column: TVirtualTreeColumn;
  i, cnt: Integer;
begin
  Clear;
  if not conn.Connected then exit;
  Table := aTable;
  Key := aKey;
  Order := aOrder;
  Where := aWhere;
  Connection:=conn;
  FFields.Clear;
  FFieldsDisp.Clear;
  FFieldsConvTo.Clear;
  FFieldsConvFrom.Clear;
  for i:=0 to length(aFields)-1 do begin
      FFields.Add(aFields[i]);
      FFieldsDisp.Add(aFieldsDisp[i]);
      FFieldsConvFrom.Add(aFieldsConvFrom[i]);
      FFieldsConvTo.Add(aFieldsConvTo[i]);
  end;
  for i:=0 to length(aMasterControls)-1 do begin
      FMasterControls.Add(aMasterControls[i]);
      FLinkFields.Add(aLinkFielsd[i]);
  end;
    Header.Options := Header.Options + [hoVisible];
    for i:=Header.Columns.Count+1 to FFields.Count-1 do begin
      Column:=Header.Columns.Add;
      Column.Width:=200;
      Column.Options:=Column.Options + [coAllowClick, coAllowFocus];
      Column.Text:=FFieldsDisp[i];
    end;
    Header.Options:=Header.Options + [hoVisible, hoAutoResize];
    TreeOptions.MiscOptions:=TreeOptions.MiscOptions
      + [toEditable, toGridExtensions];
    TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions
      + [toExtendedFocus];
    ReFill(levFull);
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

function TDBVST.SaveAll: String;
begin

end;

function TDBVST.SaveRow: String;
var
  Query: TExtSQLQuery;
  i: Integer;
  Val: String;
begin
  Query := TExtSQLQuery.Create(Self, FConnection);
  Query.SQL.Add('update ' + Table);
  Query.SQL.Add('set ');
  GetText(Self, FocusedNode, 0, ttNormal, Val);
  Query.SQL.Add(FFields[2] + ' = $$' + Val + '$$ ');
  for i:=3 to FFields.Count-1 do begin
    GetText(Self, FocusedNode, i-2, ttNormal, Val);
    Query.SQL.Add(', '+ FFields[i] + ' = $$' + Val + '$$ ');
  end;
  Query.SQL.Add('where ' + Where);
  Query.SQL.Add('and ' + FFields[0] + ' = $$' + GetSelectedID() + '$$');
  try
//    Query.ExecSQL;
  except
    on E: Exception do
      Result:=E.Message;
  end;
  Query.Free;
end;

end.
