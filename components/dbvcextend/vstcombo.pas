unit VSTCombo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  VirtualTrees, messages, StdCtrls, sqldb,
  extsqlquery;

type

  { TCBStringEditLink }

  TCBStringEditLink = class(TInterfacedObject, IVTEditLink)
  private
    FConnection: TSQLConnection;
    FEdit: TWinControl;
    FPropsList: TStrings;
    FTree: TVirtualStringTree;
    FNode: PVirtualNode;
    FColumn: Integer;
    procedure SetConnection(AValue: TSQLConnection);
    procedure SetPropsList(AValue: TStrings);
  protected
    procedure EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(aConnection: TSQLConnection; APropsList: TStrings);
    destructor Destroy; override;
    function BeginEdit: Boolean; stdcall;
    function CancelEdit: Boolean; stdcall;
    function EndEdit: Boolean; stdcall;
    function GetBounds: TRect; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
    procedure ProcessMessage(var Message: TMessage); stdcall;
    procedure SetBounds(R: TRect); stdcall;
    property PropsList: TStrings read FPropsList write SetPropsList;
    property Connection: TSQLConnection read FConnection write SetConnection;
  end;

implementation

destructor TCBStringEditLink.Destroy;
begin
  FEdit.Free;
  inherited;
end;

procedure TCBStringEditLink.SetPropsList(AValue: TStrings);
begin
  if AValue<>nil then
    FPropsList:=AValue;
end;

procedure TCBStringEditLink.SetConnection(AValue: TSQLConnection);
begin
  if FConnection=AValue then Exit;
  FConnection:=AValue;
end;

procedure TCBStringEditLink.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
{  case Key of
    chr(27):
      begin
        FTree.CancelEditNode;
        Key := 0;
        FTree.setfocus;
      end;
    chr(13):
      begin
       PostMessage(FTree.Handle, WM_KEYDOWN, VK_DOWN, 0);
       Key := 0;
       FTree.EndEditNode;
       FTree.setfocus;
      end;
  End; //case
}
end;

constructor TCBStringEditLink.Create(aConnection: TSQLConnection;
  APropsList: TStrings);
begin
  inherited Create;
  PropsList:=APropsList;
  Connection:=aConnection;
end;

function TCBStringEditLink.BeginEdit: Boolean; stdcall;
begin
  Result := True;
  //FEdit.Height:=(FTree.DefaultNodeHeight - 1); //Needed for editbox. Not combo
  FEdit.Show;
  TComboBox(FEdit).DroppedDown:=True;
  FEdit.SetFocus;
end;

function TCBStringEditLink.CancelEdit: Boolean; stdcall;
begin
  Result := True;
  FEdit.Hide;
end;

function TCBStringEditLink.EndEdit: Boolean; stdcall;
var
  S: WideString;
begin
  Result := True;
  S:= TComboBox(FEdit).Text;
  FTree.Text[FNode, FColumn] := S;

  FTree.InvalidateNode(FNode);
  FEdit.Hide;
  FTree.SetFocus;
end;

function TCBStringEditLink.GetBounds: TRect; stdcall;
begin
  Result := FEdit.BoundsRect;
end;

function TCBStringEditLink.PrepareEdit(Tree: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex): Boolean; stdcall;
var
  Query: TExtSQLQuery;
begin
  Result := True;
  FTree := Tree as TVirtualStringTree;
  FNode := Node;
  FColumn := Column;

  FEdit.Free;
  FEdit := nil;

  FEdit := TComboBox.Create(nil);
  with FEdit as TComboBox do
    begin
       Visible := False;
       Parent := Tree;
       OnKeyDown := @EditKeyDown;
      try

       Query := TExtSQLQuery.Create(nil, Connection);
       Query.SQL.Text:=PropsList.Text;
       Query.Open;
       while not Query.Eof do begin
            Items.Add(Query.Fields[0].AsString);
            Query.Next;
        end;
      finally
       Query.Free;
       Query:=nil;
      end;
    end;
end;

procedure TCBStringEditLink.ProcessMessage(var Message: TMessage); stdcall;
begin
  FEdit.WindowProc(Message);
end;

procedure TCBStringEditLink.SetBounds(R: TRect); stdcall;
var
  Dummy: Integer;
begin
  FTree.Header.Columns.GetColumnBounds(FColumn, Dummy, R.Right);
  FEdit.BoundsRect := R;
end;

End.
