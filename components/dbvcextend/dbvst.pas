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
    FKey: String;
    FConnection: TSQLConnection;
    FOrder: String;
    FSQL: TStringList;
    procedure SetConnection(AValue: TSQLConnection);
    procedure SetKey(AValue: String);
    procedure SetOrder(AValue: String);
    procedure SetSQL(AValue: TStringList);
  protected
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
    procedure FillFromQuery(conn: TSQLConnection; aQry, aKey, aOrder: String;
      levFull:integer);
    procedure FillFromQuery(conn: TSQLConnection; aQry, aKey, aOrder: String);
  published
    property SQL: TStringList read FSQL write SetSQL;
    property Key: String read FKey write SetKey;
    property Order: String read FOrder write SetOrder;
    property Connection: TSQLConnection read FConnection write SetConnection;
 end;

procedure Register;

implementation

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
  OnExpanding:=@Expanding;
  OnChange:=@Change;
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
//    writeln(Query.SQL.Text);
    Checked:=false;
    hasChecked := false;
    hasUnchecked := false;
    Query.Open;
    while not Query.Eof do
    begin
      NodeData:=TStringList.Create;
      NodeData.Add(Query.Fields[0].AsString);
      cnt := 1;
      if Query.FieldCount > cnt then
        if Query.FieldDefs[cnt].DataType = ftBoolean then begin
          Checked := Query.Fields[cnt].AsBoolean;
          hasChecked := hasChecked or Checked;
          hasUnchecked := hasUnchecked or not(Checked);
          cnt := cnt+1;
        end
        else begin
          NodeData.Add(Query.Fields[cnt].AsString);
        end
      else
        NodeData.Add(Query.Fields[0].AsString);
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

procedure TDBVST.FillFromQuery(conn: TSQLConnection; aQry, aKey, aOrder: String;
  levFull:integer);
var
  Query: TExtSQLQuery;
  Column: TVirtualTreeColumn;
  i, cnt: Integer;
begin
  Clear;
//  Header.Columns.Clear;
  Key:=aKey;
  Order:=aOrder;
  SQL.Clear;
  SQL.Add(aQry);
  Connection:=conn;
  try
    Query := TExtSQLQuery.Create(Self, FConnection);
    Query.SQL.Text:=aQry + ' limit 1 ' ;
    Query.Open;
    cnt := Query.FieldCount-1;
    if Query.FieldDefs[1].DataType = ftBoolean then cnt := cnt -1;
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
//    ScrollBarOptions.ScrollBars:=ssAutoBoth;
    FillNode(nil, levFull);
  finally
    Query.Free;
  end;
end;

procedure TDBVST.FillFromQuery(conn: TSQLConnection; aQry, aKey, aOrder: String
  );
begin
  FillFromQuery(conn, aQry, aKey, aOrder, 0)
end;

end.
