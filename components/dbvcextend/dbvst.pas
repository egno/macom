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
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  sqldb, extsqlquery, db,
  VirtualTrees;

type

  { TDBVST }

  PDBTreeData = ^TStringList;

  TDBVST = class(TVirtualStringTree)
  private
    FFields: TStringList;
    FFieldsConvFrom: TStringList;
    FFieldsConvTo: TStringList;
    FFieldsDisp: TStringList;
    FKey: String;
    FConnection: TSQLConnection;
    FOrder: String;
    FSQL: TStringList;
    FTable: String;
    FWhere: String;
    procedure SetConnection(AValue: TSQLConnection);
    procedure SetFields(AValue: TStringList);
    procedure SetFieldsConvFrom(AValue: TStringList);
    procedure SetFieldsConvTo(AValue: TStringList);
    procedure SetFieldsDisp(AValue: TStringList);
    procedure SetKey(AValue: String);
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
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure FillNode(Node: PVirtualNode; levFull:integer);
    procedure FillNode(Node: PVirtualNode);
    procedure CreateAndFill(conn: TSQLConnection; aTable:String;
      aFields, aFieldsDisp, aFieldsConvTo, aFieldsConvFrom:array of String; aKey, aWhere, aOrder: String; levFull:integer);
    function GetSelectedID(): String;
    function GetID(Node: PVirtualNode): String;
    function SaveAll():String;
    function SaveRow():String;
  published
    property SQL: TStringList read FSQL write SetSQL;
    property Table: String read FTable write SetTable;
    property Fields: TStringList read FFields write SetFields;
    property FieldsDisp: TStringList read FFieldsDisp write SetFieldsDisp;
    property FieldsConvTo: TStringList read FFieldsConvTo write SetFieldsConvTo;
    property FieldsConvFrom: TStringList read FFieldsConvFrom write SetFieldsConvFrom;
    property Key: String read FKey write SetKey;
    property Order: String read FOrder write SetOrder;
    property Where: String read FWhere write SetWhere;
    property Connection: TSQLConnection read FConnection write SetConnection;
 end;

procedure Register;

implementation

const
     WrapWidth: Integer = 80;

procedure Register;
begin
  RegisterComponents('Virtual Controls',[TDBVST]);
end;

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
  OnEdited:=@Edited;
  OnExpanding:=@Expanding;
  OnChange:=@Change;
  OnFocusChanged:=@FocusChanged;
  OnGetNodeDataSize:=@GetNodeDataSize;
  OnGetText:=@GetText;
  OnFreeNode:=@FreeNode;
  OnInitNode:=@InitNode;
  OnNewText:=@NewText;
end;

destructor TDBVST.Destroy;
begin
  inherited Destroy;
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
  Application.ProcessMessages;
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

procedure TDBVST.CreateAndFill(conn: TSQLConnection; aTable: String; aFields,
  aFieldsDisp, aFieldsConvTo, aFieldsConvFrom: array of String; aKey, aWhere,
  aOrder: String; levFull: integer);

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
  Query: TExtSQLQuery;
  Column: TVirtualTreeColumn;
  i, cnt: Integer;
begin
  Clear;
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
  FSQL.Clear;
  FSQL.Add('select ');
  FSQL.Add(GetSQLFieldString(0));
  for i:=1 to FFields.Count-1 do begin
    FSQL.Add(', '+ GetSQLFieldString(i));
  end;
  FSQL.Add(' from ' + Table);
  FSQL.Add(' where ' + Where);
  try
    Query := TExtSQLQuery.Create(Self, FConnection);
    Query.SQL.Text:=SQL.Text + ' limit 1 ' ;
    writeln (Query.SQL.Text);
    Query.Open;
    cnt := Query.FieldCount-1;
    Header.Options := Header.Options + [hoVisible];
//    if Query.FieldDefs[1].DataType = ftBoolean then cnt := cnt -1;
    for i:=Header.Columns.Count+1 to cnt do begin
      Column:=Header.Columns.Add;
      Column.Width:=200;
      Column.Options:=Column.Options + [coAllowClick, coAllowFocus];
    end;
    Header.Options:=Header.Options + [hoVisible, hoAutoResize];
    TreeOptions.MiscOptions:=TreeOptions.MiscOptions
      + [toEditable, toGridExtensions];
    TreeOptions.SelectionOptions:=TreeOptions.SelectionOptions
      + [toExtendedFocus];
    FillNode(nil, levFull);
  finally
    Query.Free;
  end;
end;

function TDBVST.GetSelectedID: String;
begin
  Result := GetID(FocusedNode);
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
  Query.SQL.Add(Fields[2] + ' = $$' + Val + '$$ ');
  for i:=3 to Fields.Count-1 do begin
    GetText(Self, FocusedNode, i-2, ttNormal, Val);
    Query.SQL.Add(', '+ Fields[i] + ' = $$' + Val + '$$ ');
  end;
  Query.SQL.Add('where ' + Where);
  Query.SQL.Add('and ' + Fields[0] + ' = $$' + GetSelectedID() + '$$');
  try
//    Query.ExecSQL;
  except
    on E: Exception do
      Result:=E.Message;
  end;
  Query.Free;
end;

end.
