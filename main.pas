unit main;

{
MaCom - Free/Libre Management Company Information System
Main unit

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
  Classes, SysUtils, FileUtil, TreeFilterEdit, Forms, Controls, Graphics,
  Dialogs, Menus, ComCtrls, ActnList, PairSplitter, StdCtrls, ExtCtrls, Buttons,
  StdActns, DBGrids, pqconnection, fpjson, jsonparser, XMLConf, sqldb, db,
  dbfunc, ExpandPanels, Grids, CheckLst, DbCtrls, IniPropStorage,
  EditBtn, DBActns, Calendar, keyvalue,
  ExtSQLQuery, DBVST, VirtualTrees;

type

  { TMainForm }

  TMainForm = class(TForm)
    ActionPanel3: TPanel;
    ActionSave: TAction;
    ActionDisconnect: TAction;
    ActionConnect: TAction;
    ActionPanel1: TPanel;
    ActPanel1: TPanel;
    BaseCB: TComboBox;
    BuildingPropertiesVST: TDBVST;
    DataSetDelete: TDataSetDelete;
    DataSetEdit: TDataSetEdit;
    DataSetInsert: TDataSetInsert;
    DataSetPost: TDataSetPost;
    BuildingsList: TDBVST;
    BuildingsFilter: TEdit;
    BuildingPersonnel: TDBVST;
    BuildingsLabel: TLabel;
    BuildingContractWorksVST: TDBVST;
    BuildingPersonnelVST: TDBVST;
    BuildingCalcPriceEdit: TEdit;
    BuildingWorkPlanFact: TDBVST;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    BuildingWorkPeriodLabel: TLabel;
    MainTree: TDBVST;
    Label11: TLabel;
    PairSplitter6: TPairSplitter;
    PairSplitterSide16: TPairSplitterSide;
    PairSplitterSide17: TPairSplitterSide;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ScrollBox4: TScrollBox;
    BuildingWorksTabSheet: TTabSheet;
    ToolButton3: TToolButton;
    WorkDateEdit: TDateEdit;
    WorkPeriodBeginEdit: TDateEdit;
    WorkPeriodBeginEdit1: TDateEdit;
    WorkVSTLabel: TLabel;
    ServiceWorks: TDBVST;
    Panel7: TPanel;
    ServicesWorksList: TDBVST;
    Panel2: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    WorksList: TDBVST;
    ServicesList: TDBVST;
    IniPropStorage: TIniPropStorage;
    Label10: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    PairSplitter5: TPairSplitter;
    PairSplitterSide14: TPairSplitterSide;
    PairSplitterSide15: TPairSplitterSide;
    Panel4: TPanel;
    PersonNote: TMemo;
    DBPopupMenu: TPopupMenu;
    Splitter3: TSplitter;
    BuildingPropsTabSheet: TTabSheet;
    BuildingPersonnelTabSheet: TTabSheet;
    WorkAddAllBtn1: TBitBtn;
    PersAddBtn: TBitBtn;
    WorkDelAllBtn1: TBitBtn;
    PersDelBtn: TBitBtn;
    WorkNameEdit: TMemo;
    WorkLabel: TLabel;
    WorkCondEdit: TMemo;
    WorkNote: TMemo;
    WorkPageControl: TPageControl;
    PairSplitter3: TPairSplitter;
    PairSplitter4: TPairSplitter;
    PairSplitterSide10: TPairSplitterSide;
    PairSplitterSide11: TPairSplitterSide;
    PairSplitterSide12: TPairSplitterSide;
    PairSplitterSide13: TPairSplitterSide;
    Panel1: TPanel;
    WorkCodeEdit: TEdit;
    WorkFactorEdit: TEdit;
    WorkResourcesVST: TDBVST;
    ServicesWorkNote: TMemo;
    PairSplitter2: TPairSplitter;
    PairSplitterSide8: TPairSplitterSide;
    PairSplitterSide9: TPairSplitterSide;
    BuildingBox: TGroupBox;
    MainIconList22: TImageList;
    BuildingDetailsMemo: TMemo;
    BuildingPageControl: TPageControl;
    PairSplitter1: TPairSplitter;
    PairSplitterSide4: TPairSplitterSide;
    PairSplitterSide7: TPairSplitterSide;
    ScrollBox3: TScrollBox;
    ServiceCompaniesVST: TDBVST;
    MainTabSheet: TTabSheet;
    WorkTabSheet: TTabSheet;
    BuildingMainTabSheet: TTabSheet;
    BuildingServicesTabSheet: TTabSheet;
    WorkPairSplitter: TPairSplitter;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide5: TPairSplitterSide;
    PairSplitterSide6: TPairSplitterSide;
    ScrollBox2: TScrollBox;
    ServiceLabel: TLabel;
    SrvMainSaveBtn1: TBitBtn;
    Panel3: TPanel;
    Splitter2: TSplitter;
    BuildingTabSheet: TTabSheet;
    WorksTabSheet: TTabSheet;
    WorkAddBtn: TBitBtn;
    WorkAddAllBtn: TBitBtn;
    WorkDelBtn: TBitBtn;
    WorkDelAllBtn: TBitBtn;
    SrvMainSaveBtn: TBitBtn;
    ConnPortEdit: TEdit;
    ConnPortLabel: TLabel;
    ConnBtn: TBitBtn;
    Conn: TPQConnection;
    Label2: TLabel;
    Label3: TLabel;
    ActPanel: TPanel;
    SrvNameEdit: TEdit;
    FileExit: TFileExit;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    BottomRollOut: TMyRollOut;
    LeftRollOut: TMyRollOut;
    MainPanel: TPanel;
    ScrollBox1: TScrollBox;
    ServicePageControl: TPageControl;
    ServicePairSplitter: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    ShowPwdBtn: TBitBtn;
    ConnBaseEdit: TEdit;
    ConnBaseLabel: TLabel;
    ConnHostEdit: TEdit;
    ConnPwdEdit: TEdit;
    ConnHostLabel: TLabel;
    ConnUserLabel: TLabel;
    ConnUserEdit: TEdit;
    ConnPwdLabel: TLabel;
    MainActionList: TActionList;
    MainMenu: TMainMenu;
    LogView: TMemo;
    LeftPageControl: TPageControl;
    CenterPageControl: TPageControl;
    MainStatusBar: TStatusBar;
    MainToolBar: TToolBar;
    LeftAllSheet: TTabSheet;
    ConnectTabSheet: TTabSheet;
    ConnScrollBox: TScrollBox;
    ActionPanel: TPanel;
    ServiceTabSheet: TTabSheet;
    ServicePropMainTabSheet: TTabSheet;
    SrvWorksTabSheet: TTabSheet;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure ActionConnectExecute(Sender: TObject);
    procedure ActionDisconnectExecute(Sender: TObject);
    procedure BuildingMainTabSheetShow(Sender: TObject);
    procedure BuildingPersonnelFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BuildingPersonnelVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BuildingPropertiesVSTColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure BuildingPropsTabSheetShow(Sender: TObject);
    procedure BuildingServicesTabSheetShow(Sender: TObject);
    procedure BuildingsListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BuildingTabSheetShow(Sender: TObject);
    procedure BuildingWorksTabSheetShow(Sender: TObject);
    procedure CenterPageControlCloseTabClicked(Sender: TObject);
    procedure DataSave(Sender: TObject);
    procedure DataSetInsertExecute(Sender: TObject);
    procedure DBPopupMenuPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MainTabSheetShow(Sender: TObject);
    procedure MainTreeDblClick(Sender: TObject);
    procedure RefreshControl(C:String);
    procedure RefreshPersonNote(ids: String);
    procedure SaveWorkDate(aDate: TDateTime);
    procedure ServiceCompaniesVSTDblClick(Sender: TObject);
    procedure ServiceCompaniesVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServicesListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServicesWorksListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServiceTabSheetShow(Sender: TObject);
    procedure BuildingPersonnelTabSheetShow(Sender: TObject);
    procedure SrvWorksTabSheetShow(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure WorkAddBtnClick(Sender: TObject);
    procedure WorkDateEditAcceptDate(Sender: TObject; var ADate: TDateTime;
      var AcceptDate: Boolean);
    procedure WorkDateEditCustomDate(Sender: TObject; var ADate: string);
    procedure WorkDateEditEditingDone(Sender: TObject);
    procedure WorkDelBtnClick(Sender: TObject);
    procedure UpdateDBTable(Table: String; Fields, Values: array of String);
    procedure FillListFromSQL(Items:TStrings ; SQL: String);
    procedure WorksListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure WorksTabSheetShow(Sender: TObject);
    procedure WorksTreeViewEnter(Sender: TObject);
    procedure WorkTabSheetShow(Sender: TObject);

  protected
  private
    procedure CheckConnected();
    procedure InitFormAfterConnect();
    procedure InitFormDisconnected();
    procedure Log(Note: String; Level: Integer = 0);
    procedure MakeVSTLabelCaption(aVST: TDBVST; aLabel: TLabel);
    procedure MakeVSTNoteText(aVST: TDBVST; aMemo: TMemo);
    procedure MainTreeFill();
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

const
  dspNotAssigned: String = '<Не указано>';
  dspDisconnected: String = 'Нет подключения';

  sqlDateFormat: String = 'DD.MM.YYYY';
  sqlStringQuote = '$$';
  sqlFieldDelimiter = ',';

procedure TMainForm.ActionConnectExecute(Sender: TObject);
begin
  Cursor:=crHourGlass;
  DBConnect(Conn, ConnUserEdit.Text, ConnPwdEdit.Text,
              ConnHostEdit.Text, ConnPortEdit.Text,
              ConnBaseEdit.Text);
  CheckConnected();
  Cursor:=crDefault;
end;

procedure TMainForm.ActionDisconnectExecute(Sender: TObject);
begin
  DBDisconnect(Conn);
  CheckConnected();
end;

procedure TMainForm.BuildingMainTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if (BuildingsList.SelectedCount > 0) then begin
    BuildingDetailsMemo.Text:=ReturnStringSQL(Conn,
      'select array_to_string(array_agg(note), chr(13)||$$-------$$||chr(13)) from buildings where id in ('
      + BuildingsList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
      +')');
    BuildingCalcPriceEdit.Text:=ReturnStringSQL(Conn,
          'select round(sum(year_price))::text '
          + ' from c_service_price where building in ('
          + BuildingsList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
          + ') '
          );
  end
  else begin
    BuildingDetailsMemo.Clear;
    BuildingCalcPriceEdit.Text:='';
  end;
end;

procedure TMainForm.BuildingPersonnelFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  RefreshPersonNote(
    (Sender as TDBVST).GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter));
end;

procedure TMainForm.BuildingPersonnelVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  RefreshPersonNote(
    (Sender as TDBVST).GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter));
end;

procedure TMainForm.BuildingPropertiesVSTColumnDblClick(
  Sender: TBaseVirtualTree; Column: TColumnIndex; Shift: TShiftState);
begin
  BuildingPropertiesVST.EditNode(BuildingPropertiesVST.FocusedNode, Column);
end;

procedure TMainForm.BuildingPropsTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  BuildingPropertiesVST.Refill;
end;

procedure TMainForm.BuildingServicesTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  ServiceCompaniesVST.ReFill;
  BuildingContractWorksVST.ReFill;
end;



procedure TMainForm.BuildingsListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  if (not Conn.Connected) then exit;
  MakeVSTLabelCaption(BuildingsList, BuildingsLabel);
  BuildingPageControl.ActivePage.OnShow(Sender);
end;

procedure TMainForm.BuildingTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if Assigned(BuildingsList.GetFirst()) then exit;
//  Log('...получение справочника домов');
  BuildingsList.ReFill;
end;

procedure TMainForm.BuildingWorksTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  BuildingWorkPeriodLabel.Caption:=ReturnStringSQL(Conn,
    'select to_char(work_date(),$$mm.yyyy$$)');
  BuildingWorkPlanFact.ReFill();
end;

procedure TMainForm.CenterPageControlCloseTabClicked(Sender: TObject);
begin
  (Sender as TTabSheet).TabVisible:=False;
end;

procedure TMainForm.DataSave(Sender: TObject);
begin
end;

procedure TMainForm.DataSetInsertExecute(Sender: TObject);
var
  Node : PVirtualNode;
  NodeData: TStringList;
begin
  if ActiveControl.ClassNameIs('TDBVST') then
    with (ActiveControl as TDBVST) do begin
      NodeData:=TStringList.Create;
      NodeData.Add('');
      NodeData.Add('');
      NodeData.Add('');
      Node:=AddChild(nil, NodeData);
      (ActiveControl as TDBVST).FocusedNode:=Node;
      (ActiveControl as TDBVST).EditNode(Node,0);
  end;
end;

procedure TMainForm.DBPopupMenuPopup(Sender: TObject);
begin
  Log (ActiveControl.ClassName);
//  DataSetInsert.Enabled := (ActiveControl.ClassName = 'DBVST');
end;



procedure TMainForm.FormShow(Sender: TObject);
begin
  DBDisconnect(Conn);
  CheckConnected();
end;

procedure TMainForm.MainTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if WorksList.GetSelectedID() = '' then exit;
  WorkNameEdit.Text:=ReturnStringSQL(Conn,
          'select disp from works where id = '
          + WorksList.GetSQLSelectedID(sqlStringQuote)
          );
  WorkCodeEdit.Text:=ReturnStringSQL(Conn,
          'select code::text from works where id = '
          + WorksList.GetSQLSelectedID(sqlStringQuote)
          );
  BaseCB.Text:=ReturnStringSQL(Conn,
          'select base::text from works where id = '
          + WorksList.GetSQLSelectedID(sqlStringQuote)
          );
  WorkFactorEdit.Text:=ReturnStringSQL(Conn,
          'select factor::text from works where id = '
          + WorksList.GetSQLSelectedID(sqlStringQuote)
          );
  WorkCondEdit.Text:=ReturnStringSQL(Conn,
          'select condition::text from works where id = '
          + WorksList.GetSQLSelectedID(sqlStringQuote)
          );
  MakeVSTNoteText(WorksList, WorkNote);
end;

procedure TMainForm.MainTreeDblClick(Sender: TObject);
var
  xName: String;
  xComponent: TComponent;
begin
  if not Conn.Connected then exit;
  xName:=ReturnStringSQL(Conn, 'select mode from app.maintree where id = '
    + MainTree.GetSQLSelectedID(sqlStringQuote)) + 'TabSheet';
  xComponent:=CenterPageControl.FindChildControl(xName);
  if not Assigned(xComponent) then exit;
  if not xComponent.ClassNameIs('TTabSheet') then exit;
  (xComponent as TTabSheet).TabVisible:=True;
  CenterPageControl.ActivePage:=(xComponent as TTabSheet);
end;


procedure TMainForm.RefreshControl(C:String);
var
  p: TComponent;
  VSTNodeData: PDBTreeData;
  Json: TJSONParser;
  tid: String;
begin
  p:=FindComponent(C);
  if p = nil then Exit;
  (p as TControl).Cursor:=crSQLWait;
end;

procedure TMainForm.RefreshPersonNote(ids: String);
begin
  PersonNote.Clear;
  try
    PersonNote.Text:=ReturnStringSQL(Conn,
      'select array_to_string(array_agg(disp), '
      + ' chr(13)||$$-------$$||chr(13)) from ( '
      + 'select max(contract_disp) || chr(13) || '
      + ' (array_agg(code::text || $$: $$ || val::text))::text disp '
      + ' from all_staff_params '
      + ' where val is not null and contract IN ('
      + ids
      +') group by contract ) q');
  finally
  end;
end;

procedure TMainForm.SaveWorkDate(aDate: TDateTime);
begin
  if QWord(aDate) > 0 then begin
//    ExecSQL(Conn, '');
//    Log('Расчётная дата: ' + DateToStr(aDate));
  end;
  WorkDateEdit.Date:=StrToDate(ReturnStringSQL(Conn, 'select work_date()'));
end;

procedure TMainForm.ServiceCompaniesVSTDblClick(Sender: TObject);
begin
  ServiceCompaniesVST.EditNode(ServiceCompaniesVST.FocusedNode,
    ServiceCompaniesVST.FocusedColumn);
end;


procedure TMainForm.ServiceCompaniesVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  BuildingContractWorksVST.ReFill;
end;

procedure TMainForm.ServicesListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  MakeVSTLabelCaption(ServicesList, ServiceLabel);
  ServicePageControl.ActivePage.OnShow(Sender);
end;

procedure TMainForm.ServicesWorksListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  MakeVSTNoteText(Sender as TDBVST, ServicesWorkNote);
end;

procedure TMainForm.ServiceTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if Assigned(ServicesList.GetFirst()) then exit;
//  Log('...получение справочника услуг');
  ServicesList.Refill;
end;

procedure TMainForm.BuildingPersonnelTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
//  if Assigned(BuildingPersonnel.GetFirst()) then exit;
  if not Assigned(BuildingPersonnel.GetFirst()) then begin
//     Log('...получение справочника персонала');
     BuildingPersonnel.ReFill;
  end;
  BuildingPersonnelVST.ReFill;
end;

procedure TMainForm.SrvWorksTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if not Assigned(ServicesWorksList.GetFirst()) then begin
//    Log('...получение справочника работ');
    ServicesWorksList.ReFill;
  end;
  ServiceWorks.ReFill;
end;

procedure TMainForm.ToolButton3Click(Sender: TObject);
begin

end;

procedure TMainForm.ToolButton4Click(Sender: TObject);
begin
  MainForm.Cursor:=crHourGlass;
end;


procedure TMainForm.WorkAddBtnClick(Sender: TObject);
var
  i: Integer;
begin
  case (Sender as TComponent).Name of
    'WorkAddBtn': begin
      ServiceWorks.AddFromQuery('select w.id, s.id '
        + ' from services s, works w '
        + ' where s.id in ('
        + ServicesList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        + ' and w.id in ('
        + ServicesWorksList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        );
    end;

    'PersAddBtn': begin
      BuildingPersonnelVST.AddFromQuery('select s.id, b.id '
        + ' from pers_contracts s, buildings b '
        + ' where b.id in ('
        + BuildingsList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        + ' and s.id in ('
        + BuildingPersonnel.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        );
    end;
  end;
end;

procedure TMainForm.WorkDateEditAcceptDate(Sender: TObject;
  var ADate: TDateTime; var AcceptDate: Boolean);
begin
  SaveWorkDate(ADate);
end;

procedure TMainForm.WorkDateEditCustomDate(Sender: TObject; var ADate: string);
begin

end;

procedure TMainForm.WorkDateEditEditingDone(Sender: TObject);
begin
  SaveWorkDate((Sender as TDateEdit).Date);
end;

procedure TMainForm.WorkDelBtnClick(Sender: TObject);
var
  i: Integer;
begin
  case (Sender as TComponent).Name of
    'WorkDelBtn': begin
      ServiceWorks.DelFromWhere(' service in ('
        + ServicesList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        + ' and work in ( '
        + ServiceWorks.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        );
    end;

    'PersDelBtn': begin
      BuildingPersonnelVST.DelFromWhere(' contract in ('
        + BuildingPersonnelVST.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        + ' and building in ( '
        + BuildingsList.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        + ') '
        );
    end;
  end;
end;

procedure TMainForm.UpdateDBTable(Table: String; Fields, Values: array of String
  );
begin

end;

procedure TMainForm.FillListFromSQL(Items: TStrings; SQL: String);
var
  Query: TExtSQLQuery;
  Data: TKeyValue;
begin
  Query:=TExtSQLQuery.Create(Self, Conn);
  try
    Query.SQL.Add(SQL);
    Query.Open;
    while not Query.EOF do begin
      Data:=TKeyValue.Create(Query.Fields[0].AsString, Query.Fields[1].AsString);
      Items.AddObject(Query.Fields[1].AsString, Data);
      Query.Next;
    end;
  except
    on E: Exception do
      Log(E.Message);
  end;
  Query.Free;
end;

procedure TMainForm.WorksListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  MakeVSTLabelCaption(WorksList, WorkVSTLabel);
  WorkPageControl.ActivePage.OnShow(Sender);
end;

procedure TMainForm.WorksTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if Assigned(WorksList.GetFirst()) then exit;
//  Log('...получение справочника работ');
  WorksList.ReFill;
end;

procedure TMainForm.WorksTreeViewEnter(Sender: TObject);
begin

end;

procedure TMainForm.WorkTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  WorkResourcesVST.ReFill;
end;


procedure TMainForm.CheckConnected;
begin
  ActionDisconnect.Enabled:=Conn.Connected;
  ActionConnect.Enabled:=not(Conn.Connected);
  RefreshControl('MainStatusBar');
  if Conn.Connected then
    InitFormAfterConnect()
  else
    InitFormDisconnected();
end;

procedure TMainForm.InitFormAfterConnect;
begin
  if not Conn.Connected then Exit;
  Cursor:=crSQLWait;
  Log('Подключено');
  ConnectTabSheet.TabVisible:=False;


  SaveWorkDate(TDateTime(0));
  Panel11.Enabled:=True;

  MainTreeFill;
  LeftRollOut.Collapsed:=False;
  BottomRollOut.Collapsed:=True;
{
  BuildingTabSheet.TabVisible:=True;
  CenterPageControl.ActivePage:=BuildingTabSheet;
}
  Cursor:=crDefault;
end;

procedure TMainForm.InitFormDisconnected;
var i: Integer;
begin
  if Conn.Connected then DBDisconnect(Conn);
  Log('Отключено');
  for i:=0 to CenterPageControl.PageCount-1 do
    CenterPageControl.Pages[i].TabVisible:=False;
  ConnectTabSheet.TabVisible:=True;
  CenterPageControl.ActivePage:=ConnectTabSheet;
  Panel11.Enabled:=false;
  BottomRollOut.Collapsed:=False;
end;

procedure TMainForm.Log(Note: String; Level: Integer);
begin
  if length(Note)>0 then
    LogView.Lines.Append(DateTimeToStr(Now) + chr(9)+ Note);
  LogView.SelStart:=Length(LogView.Text);
  BottomRollOut.Collapsed:=False;
  Application.ProcessMessages();
end;

procedure TMainForm.MakeVSTLabelCaption(aVST: TDBVST; aLabel: TLabel);
begin
  if (not Conn.Connected) then exit;
  if (aVST.SelectedCount > 0) then begin
    aLabel.Caption:= ReturnStringSQL(Conn,
      'select ' + aVST.DBFields[1] + '  from ' + aVST.DBTable + ' where ' + aVST.DBFields[0] + ' = '
      + aVST.GetSQLSelectedID(sqlStringQuote)
      );
    aLabel.Font.Style:=aLabel.Font.Style-[fsBold];
    if (aVST.SelectedCount > 1) then begin
      aLabel.Caption:= '['
        + ReturnStringSQL(Conn,
        'select count(*)::text from ' + aVST.DBTable + ' where '
        + aVST.DBFields[0] + ' in ('
        + aVST.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
        +')')
        + '] '
        + aLabel.Caption ;
        aLabel.Font.Style:=aLabel.Font.Style+[fsBold];
    end;
  end
  else begin
    aLabel.Caption:='';
  end;
end;

procedure TMainForm.MakeVSTNoteText(aVST: TDBVST; aMemo: TMemo);
begin
  aMemo.Clear;
  try
    aMemo.Text:=ReturnStringSQL(Conn,
      'select array_to_string(array_agg(' + aVST.DBFields[1] + '), '
      + ' chr(13)||$$-------$$||chr(13)) from ' + aVST.DBTable
      + ' where ' + aVST.DBFields[0] + '  IN ('
      + aVST.GetSQLSelectedIDs(sqlStringQuote, sqlFieldDelimiter)
      + ')' );
  finally
  end;
end;

procedure TMainForm.MainTreeFill;
begin
  MainTree.ReFill;
end;

end.

