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
  Classes, SysUtils, FileUtil, TreeFilterEdit, ExtendedNotebook, SynExportHTML,
  SynHighlighterHTML, IpHtml, Ipfilebroker, Forms, Controls, Graphics, Dialogs,
  Menus, ComCtrls, ActnList, PairSplitter, StdCtrls, ExtCtrls, Buttons,
  StdActns, DBGrids, pqconnection, fpjson, jsonparser, XMLConf, sqldb, db,
  dbfunc, Grids, CheckLst, DbCtrls, IniPropStorage, EditBtn, DBActns, Calendar,
  keyvalue, ExtSQLQuery, DBVST, ExpandPanels, VirtualTrees, htmlreport;

type

  { TMainForm }

  TMainForm = class(TForm)
    ActionPrint: TAction;
    BuildingWorkPlanFact1: TDBVST;
    DBVEdit2: TDBVEdit;
    DBVEdit3: TDBVEdit;
    DBVEdit4: TDBVEdit;
    DBVEdit5: TDBVEdit;
    DBVEdit6: TDBVEdit;
    DBVEdit7: TDBVEdit;
    DBVEdit8: TDBVEdit;
    BuildingWorkPers: TDBVEdit;
    DBVMemo1: TDBVMemo;
    DBVMemo2: TDBVMemo;
    DBVMemo4: TDBVMemo;
    DBVMemo5: TDBVMemo;
    DBVST1: TDBVST;
    Label15: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label8: TLabel;
    MenuSplitter: TPairSplitter;
    PairSplitter1: TPairSplitter;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide4: TPairSplitterSide;
    PairSplitterSide5: TPairSplitterSide;
    PairSplitterSide6: TPairSplitterSide;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    ScrollBox5: TScrollBox;
    ScrollBox6: TScrollBox;
    ServicesLabel: TToggleBox;
    DateLabel: TToggleBox;
    MenuLabel: TToggleBox;
    ShowServices: TAction;
    ShowBuildings: TAction;
    ActionSave: TAction;
    ActionDisconnect: TAction;
    ActionConnect: TAction;
    ActPanel1: TPanel;
    BuildingPropertiesVST: TDBVST;
    DataSetDelete: TDataSetDelete;
    DataSetEdit: TDataSetEdit;
    DataSetInsert: TDataSetInsert;
    DataSetPost: TDataSetPost;
    BuildingsList: TDBVST;
    BuildingsFilter: TEdit;
    BuildingPersonnel: TDBVST;
    BuildingContractWorksVST: TDBVST;
    BuildingPersonnelVST: TDBVST;
    BuildingWorkPlanFact: TDBVST;
    LeftTabs: TExtendedNotebook;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    BuildingWorkPeriodLabel: TLabel;
    MainTree: TDBVST;
    BottomRollOut: TMyRollOut;
    PairSplitter6: TPairSplitter;
    MainSplitter: TPairSplitter;
    PairSplitterSide1: TPairSplitterSide;
    PairSplitterSide16: TPairSplitterSide;
    PairSplitterSide17: TPairSplitterSide;
    PairSplitterSide2: TPairSplitterSide;
    Panel10: TPanel;
    ModesPanel: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ScrollBox4: TScrollBox;
    MainBuildingsTabSheet: TTabSheet;
    MainServicesTabSheet: TTabSheet;
    MainDatesTabSheet: TTabSheet;
    BuildingServicesTabSheet: TTabSheet;
    BuildingPersonnelTabSheet: TTabSheet;
    BuildingWorksTabSheet: TTabSheet;
    BuildingsLabel: TToggleBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ReportTabSheet: TTabSheet;
    ToolButton4: TToolButton;
    WorkDateEdit: TDateEdit;
    WorkPeriodBeginEdit: TDateEdit;
    WorkPeriodEndEdit: TDateEdit;
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
    WorkAddAllBtn1: TBitBtn;
    PersAddBtn: TBitBtn;
    WorkDelAllBtn1: TBitBtn;
    PersDelBtn: TBitBtn;
    WorkLabel: TLabel;
    WorkPageControl: TPageControl;
    PairSplitter3: TPairSplitter;
    PairSplitter4: TPairSplitter;
    PairSplitterSide10: TPairSplitterSide;
    PairSplitterSide11: TPairSplitterSide;
    PairSplitterSide12: TPairSplitterSide;
    PairSplitterSide13: TPairSplitterSide;
    Panel1: TPanel;
    WorkResourcesVST: TDBVST;
    ServicesWorkNote: TMemo;
    PairSplitter2: TPairSplitter;
    PairSplitterSide8: TPairSplitterSide;
    PairSplitterSide9: TPairSplitterSide;
    BuildingBox: TGroupBox;
    MainIconList22: TImageList;
    BuildingPageControl: TPageControl;
    ScrollBox3: TScrollBox;
    MainTabSheet: TTabSheet;
    WorkTabSheet: TTabSheet;
    BuildingMainTabSheet: TTabSheet;
    ScrollBox2: TScrollBox;
    Panel3: TPanel;
    Splitter2: TSplitter;
    BuildingTabSheet: TTabSheet;
    WorksTabSheet: TTabSheet;
    WorkAddBtn: TBitBtn;
    WorkAddAllBtn: TBitBtn;
    WorkDelBtn: TBitBtn;
    WorkDelAllBtn: TBitBtn;
    ConnPortEdit: TEdit;
    ConnPortLabel: TLabel;
    ConnBtn: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    ActPanel: TPanel;
    FileExit: TFileExit;
    Label1: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MainPanel: TPanel;
    ScrollBox1: TScrollBox;
    ServicePageControl: TPageControl;
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
    CenterPageControl: TPageControl;
    MainStatusBar: TStatusBar;
    MainToolBar: TToolBar;
    ConnectTabSheet: TTabSheet;
    ConnScrollBox: TScrollBox;
    ActionPanel: TPanel;
    ServiceTabSheet: TTabSheet;
    ServicePropMainTabSheet: TTabSheet;
    SrvWorksTabSheet: TTabSheet;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Conn: TPQConnection;
    procedure ActionConnectExecute(Sender: TObject);
    procedure ActionDisconnectExecute(Sender: TObject);
    procedure ActionPrintExecute(Sender: TObject);
    procedure BuildingLabelClick(Sender: TObject);
    procedure BuildingMainTabSheetShow(Sender: TObject);
    procedure BuildingPersonnelFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BuildingPersonnelVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BuildingPropertiesVSTColumnDblClick(Sender: TBaseVirtualTree;
      Column: TColumnIndex; Shift: TShiftState);
    procedure BuildingPropsTabSheetShow(Sender: TObject);
    procedure BuildingServicesTabSheetShow(Sender: TObject);
    procedure BuildingWorkPlanFactFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure DBVEdit5Exit(Sender: TObject);
    procedure DBVEdit8Change(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure MainDatesTabSheetContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MainPanelClick(Sender: TObject);
    procedure MainToggleClick(Sender: TObject);
    procedure BuildingsListDblClick(Sender: TObject);
    procedure BuildingsListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure BuildingTabSheetShow(Sender: TObject);
    procedure BuildingWorksTabSheetShow(Sender: TObject);
    procedure CheckDepends(aControl: TControl);
    procedure CenterPageControlChange(Sender: TObject);
    procedure CenterPageControlCloseTabClicked(Sender: TObject);
    procedure DataSetInsertExecute(Sender: TObject);
    procedure DateLabelClick(Sender: TObject);
    procedure DBPopupMenuPopup(Sender: TObject);
    procedure ForceSelect(aName: String);
    procedure FormShow(Sender: TObject);
    procedure LeftTabsMouseLeave(Sender: TObject);
    procedure LeftTabsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainTabSheetShow(Sender: TObject);
    procedure MainTreeDblClick(Sender: TObject);
    procedure MainTreeFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure MenuLabelChange(Sender: TObject);
    procedure MenuLabelClick(Sender: TObject);
    procedure OpenPage(aName, aCaption: String);
    procedure OpenPage(aName: String);
    procedure RefreshControl(C:String);
    procedure RefreshControlsBuildingsList(Sender: TObject);
    procedure RefreshControlsServicesList(Sender: TObject);
    procedure RefreshDates();
    procedure RefreshPersonNote(ids: String);
    procedure SaveWorkDate(aDate: TDateTime);
    procedure SaveWorkPeriod(aDate1, aDate2: TDateTime);
    procedure ServiceLabelClick(Sender: TObject);
    procedure ShowBuildingsExecute(Sender: TObject);
    procedure ShowMain();
    procedure ShowDatesList();
    procedure ShowBuildingsList();
    procedure ShowPwdBtnClick(Sender: TObject);
    procedure ShowServicesList();
    procedure ServiceCompaniesVSTDblClick(Sender: TObject);
    procedure ServiceCompaniesVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServicesListDblClick(Sender: TObject);
    procedure ServicesListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServicesWorksListFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServiceTabSheetShow(Sender: TObject);
    procedure BuildingPersonnelTabSheetShow(Sender: TObject);
    procedure ShowServicesExecute(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SrvWorksTabSheetShow(Sender: TObject);
    procedure TabSheetShow(Sender: TObject);
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
    procedure WorksListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
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
    procedure MakeVSTLabel(aVST: TDBVST; aLabel: TToggleBox; aPrefix: String = '');
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
  cPanelWidth: Integer = 300;

  dspNotAssigned: String = '<Не указано>';
  dspDisconnected: String = 'Нет подключения';

  dspBtnCaptionLeft: String = '<';
  dspBtnCaptionRight: String = '>';

  sqlDateFormat: String = 'DD.MM.YYYY';
  sqlStringQuote = '$$';
  sqlFieldDelimiter = ',';

procedure TMainForm.ActionConnectExecute(Sender: TObject);
var
  xErrMsg: String;
begin
  Cursor:=crHourGlass;
  xErrMsg:='';
  DBConnect(Conn, ConnUserEdit.Text, ConnPwdEdit.Text,
              ConnHostEdit.Text, ConnPortEdit.Text,
              ConnBaseEdit.Text, xErrMsg);
  if xErrMsg <> '' then
    Log(xErrMsg);
  CheckConnected();
  Cursor:=crDefault;
end;

procedure TMainForm.ActionDisconnectExecute(Sender: TObject);
begin
  DBDisconnect(Conn);
  CheckConnected();
end;

procedure TMainForm.ActionPrintExecute(Sender: TObject);
begin
  log(ActiveControl.Name);
  ToolButton3Click(Sender);
end;

procedure TMainForm.BuildingLabelClick(Sender: TObject);
begin
  ShowBuildingsList;
end;

procedure TMainForm.BuildingMainTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
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
  CheckDepends(Sender as TWinControl);
  BuildingContractWorksVST.ReFill;
end;

procedure TMainForm.BuildingWorkPlanFactFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  BuildingWorkPlanFact1.ReFill;
  BuildingWorkPers.ReFill;
end;

procedure TMainForm.DBVEdit5Exit(Sender: TObject);
begin

end;

procedure TMainForm.DBVEdit8Change(Sender: TObject);
begin

end;

procedure TMainForm.Label17Click(Sender: TObject);
begin

end;

procedure TMainForm.MainDatesTabSheetContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin

end;

procedure TMainForm.MainPanelClick(Sender: TObject);
begin

end;

procedure TMainForm.MainToggleClick(Sender: TObject);
begin
  if not Sender.ClassNameIs('TTogglebox') then exit;
  if not ((Sender as TTogglebox).Checked) then begin
    MainSplitter.Position:=0;
    SpeedButton7.Caption:='X';
  end
  else begin
    case (Sender as TControl).Name of
      'BuildingsLabel': ShowBuildingsList;
      'ServicesLabel': ShowServicesList;
      'DateLabel': ShowDatesList;
    end;
  end;
end;

procedure TMainForm.BuildingsListDblClick(Sender: TObject);
begin
  OpenPage('BuildingTabSheet');
end;

procedure TMainForm.BuildingsListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  RefreshControlsBuildingsList(Sender);
end;

procedure TMainForm.BuildingTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  if not Assigned(BuildingPageControl.ActivePage) then exit;
  BuildingPageControl.ActivePage.OnShow(Sender);
end;

procedure TMainForm.BuildingWorksTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  CheckDepends(BuildingWorksTabSheet);
  BuildingWorkPeriodLabel.Caption:=ReturnStringSQL(Conn,
    'select to_char(work_date(),$$mm.yyyy$$)');
  BuildingWorkPlanFact.ReFill();
end;

procedure TMainForm.CheckDepends(aControl: TControl);
var
  i, j: Integer;
  xComponent: TComponent;
begin
  if not Assigned(aControl) then exit;
  case aControl.ClassName of
    'TTabSheet','TPanel','TPageControl','TScrollBox','TPairSplitterSide',
    'TPairSplitter','TDBVST', 'TDBVMemo', 'TDBVEdit': begin
      case aControl.ClassName of
        'TDBVST': with (aControl as TDBVST) do begin
          for j:=0 to DBMasterControls.Count-1 do begin
            xComponent:=Self.FindComponent(DBMasterControls.Strings[j]);
            if not Assigned(xComponent) then exit;
            if not xComponent.ClassNameIs('TDBVST') then exit;
            if (xComponent as TDBVST).SelectedCount<1 then begin
              ForceSelect(xComponent.Name);
              xComponent:=nil;
              exit;
            end;
            xComponent:=nil;
          end;
          Cursor:=crHourGlass;
          ReFill;
          Cursor:=crDefault;
        end;
        'TDBVMemo': with (aControl as TDBVMemo) do begin
          for j:=0 to DBMasterControls.Count-1 do begin
            xComponent:=Self.FindComponent(DBMasterControls.Strings[j]);
            if not Assigned(xComponent) then exit;
            if not xComponent.ClassNameIs('TDBVST') then exit;
            if (xComponent as TDBVST).SelectedCount<1 then begin
              ForceSelect(xComponent.Name);
              xComponent:=nil;
              exit;
            end;
            xComponent:=nil;
          end;
          Cursor:=crHourGlass;
          ReFill;
          Cursor:=crDefault;
        end;
        'TDBVEdit': with (aControl as TDBVEdit) do begin
          for j:=0 to DBMasterControls.Count-1 do begin
            xComponent:=Self.FindComponent(DBMasterControls.Strings[j]);
            if not Assigned(xComponent) then exit;
            if not xComponent.ClassNameIs('TDBVST') then exit;
            if (xComponent as TDBVST).SelectedCount<1 then begin
              ForceSelect(xComponent.Name);
              xComponent:=nil;
              exit;
            end;
            xComponent:=nil;
          end;
          Cursor:=crHourGlass;
          ReFill;
          Cursor:=crDefault;
        end;
      end;
      for i:=0 to (aControl as TWinControl).ControlCount-1 do begin
        CheckDepends((aControl as TWinControl).Controls[i]);
      end;
    end;
  end;
end;

procedure TMainForm.CenterPageControlChange(Sender: TObject);
begin

end;

procedure TMainForm.CenterPageControlCloseTabClicked(Sender: TObject);
begin
  (Sender as TTabSheet).TabVisible:=False;
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

procedure TMainForm.DateLabelClick(Sender: TObject);
begin
  ShowDatesList;
end;

procedure TMainForm.DBPopupMenuPopup(Sender: TObject);
begin
//  Log (ActiveControl.ClassName);
//  DataSetInsert.Enabled := (ActiveControl.ClassName = 'DBVST');
end;

procedure TMainForm.ForceSelect(aName: String);
begin
  case aName of
    'BuildingsList': begin
      ShowBuildingsList;
      Log('Необходимо выбрать здания');
    end;
    'ServicesList': begin
      ShowServicesList;
      Log('Необходимо выбрать услуги');
    end;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DBDisconnect(Conn);
  CheckConnected();
end;

procedure TMainForm.LeftTabsMouseLeave(Sender: TObject);
begin
  MainSplitter.Position := LeftTabs.Width - MainDatesTabSheet.Width;
end;

procedure TMainForm.LeftTabsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ShowMain;
end;


procedure TMainForm.MainTabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
end;

procedure TMainForm.MainTreeDblClick(Sender: TObject);
var
  xName: String;
begin
  if not Conn.Connected then exit;
  xName:=ReturnStringSQL(Conn, 'select mode from app_maintree where id = '
    + MainTree.GetSQLSelectedID(sqlStringQuote)) + 'TabSheet';
  OpenPage(xName, ReturnStringSQL(Conn, 'select disp from app_maintree where id = '
    + MainTree.GetSQLSelectedID(sqlStringQuote)));
end;

procedure TMainForm.MainTreeFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  MainTreeDblClick(Sender);
end;

procedure TMainForm.MenuLabelChange(Sender: TObject);
begin
  if not (MenuLabel.Checked) then begin
    MenuSplitter.Position:=SpeedButton1.Width;
    SpeedButton1.Caption:=dspBtnCaptionRight;
  end
  else begin
    MenuSplitter.Position:=cPanelWidth;
    SpeedButton1.Caption:=dspBtnCaptionLeft;
  end;
end;

procedure TMainForm.MenuLabelClick(Sender: TObject);
begin

end;

procedure TMainForm.OpenPage(aName, aCaption: String);
var
  xComponent: TComponent;
begin
  xComponent:=CenterPageControl.FindChildControl(aName);
  if not Assigned(xComponent) then exit;
  if not xComponent.ClassNameIs('TTabSheet') then exit;
  (xComponent as TTabSheet).TabVisible:=True;
  (xComponent as TTabSheet).BringToFront;
  if length(aCaption) > 0 then
    (xComponent as TTabSheet).Caption:=aCaption;
  CenterPageControl.ActivePage:=(xComponent as TTabSheet);
end;

procedure TMainForm.OpenPage(aName: String);
begin
  OpenPage(aName, '');
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

procedure TMainForm.RefreshControlsBuildingsList(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  MainBuildingsTabSheet.Caption:=IntToStr(BuildingsList.SelectedCount);
  MakeVSTLabel(BuildingsList, BuildingsLabel, 'Здания: ');
  if not Assigned(CenterPageControl.ActivePage) then exit;
  CenterPageControl.ActivePage.OnShow(CenterPageControl.ActivePage);
end;

procedure TMainForm.RefreshControlsServicesList(Sender: TObject);
begin

  if (not Conn.Connected) then exit;
  MainServicesTabSheet.Caption:=IntToStr(ServicesList.SelectedCount);

  MakeVSTLabel(ServicesList, ServicesLabel,'Услуги: ');
  if not Assigned(CenterPageControl.ActivePage) then exit;
  CenterPageControl.ActivePage.OnShow(CenterPageControl.ActivePage);
end;

procedure TMainForm.RefreshDates;
begin
  WorkDateEdit.Date:=StrToDate(ReturnStringSQL(Conn, 'select work_date()'));
  MainDatesTabSheet.Caption:=FormatDateTime('d.m',WorkDateEdit.Date);
  DateLabel.Caption:='РД: '+ FormatDateTime('dd.mm.yyyy',WorkDateEdit.Date)
    + ' (' +FormatDateTime('dd.mm.yy',WorkPeriodBeginEdit.Date)
    + '-' + FormatDateTime('dd.mm.yy',WorkPeriodEndEdit.Date) + ')';

  WorkPeriodBeginEdit.Date:=StrToDate(ReturnStringSQL(Conn,
    'select lower(work_period())'));
  WorkPeriodEndEdit.Date:=StrToDate(ReturnStringSQL(Conn,
    'select (upper(work_period())-1)'));

  DateLabel.Caption:='РД: '+ FormatDateTime('dd.mm.yyyy',WorkDateEdit.Date)
    + ' (' +FormatDateTime('dd.mm.yy',WorkPeriodBeginEdit.Date)
    + '-' + FormatDateTime('dd.mm.yy',WorkPeriodEndEdit.Date) + ')';

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
var
  xDate: String;
begin
  if QWord(aDate) > 0 then begin
    xDate:= ReturnStringSQL(Conn, 'select work_date($$'
      +FormatDateTime('yyyy-mm-dd',aDate)+'$$::date)');
  end
  else
    xDate:=ReturnStringSQL(Conn, 'select work_date(NULL::date)');
//  Log('Расчётная дата: ' + xDate);
  RefreshDates;
end;

procedure TMainForm.SaveWorkPeriod(aDate1, aDate2: TDateTime);
var
  xDate1, xDate2, xPeriod: String;
begin

  if QWord(aDate1) > 0 then
    xDate1:=sqlStringQuote+FormatDateTime('yyyy-mm-dd',aDate1)+sqlStringQuote
      + '::date'
  else
    xDate1:='NULL';
  if QWord(aDate2) > 0 then
    xDate2:=sqlStringQuote+FormatDateTime('yyyy-mm-dd',aDate2)+sqlStringQuote
      + '::date'
  else
    xDate2:='NULL';
  xPeriod:=ReturnStringSQL(Conn, 'select work_period('+xDate1
    + ',' + xDate2
    +')::text');

  RefreshDates;
end;

procedure TMainForm.ServiceLabelClick(Sender: TObject);
begin
  ShowServicesList;
end;

procedure TMainForm.ShowBuildingsExecute(Sender: TObject);
begin
  ShowBuildingsList;
end;

procedure TMainForm.ShowMain;
begin
  if (DateLabel.Checked or BuildingsLabel.Checked
      or ServicesLabel.Checked) then begin
    MainSplitter.Position:=cPanelWidth;
    SpeedButton7.Caption:='X';
    ActiveControl:=LeftTabs;
  end;
end;

procedure TMainForm.ShowDatesList;
begin
  DateLabel.Checked:=True;
  BuildingsLabel.Checked:=False;
  ServicesLabel.Checked:=False;
  ShowMain;
  LeftTabs.ActivePage:=MainDatesTabSheet;
end;

procedure TMainForm.ShowBuildingsList;
begin
  DateLabel.Checked:=False;
  BuildingsLabel.Checked:=True;
  ServicesLabel.Checked:=False;
  ShowMain;
  LeftTabs.ActivePage:=MainBuildingsTabSheet;
end;

procedure TMainForm.ShowPwdBtnClick(Sender: TObject);
begin
  ConnPwdEdit.EchoMode:=emNormal;
end;

procedure TMainForm.ShowServicesList;
begin
  DateLabel.Checked:=False;
  BuildingsLabel.Checked:=False;
  ServicesLabel.Checked:=True;
  ShowMain;
  LeftTabs.ActivePage:=MainServicesTabSheet;
end;

procedure TMainForm.ServiceCompaniesVSTDblClick(Sender: TObject);
begin
end;


procedure TMainForm.ServiceCompaniesVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  BuildingContractWorksVST.ReFill;
end;

procedure TMainForm.ServicesListDblClick(Sender: TObject);
begin
  OpenPage('ServiceTabSheet');
end;

procedure TMainForm.ServicesListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  RefreshControlsServicesList(Sender);
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
  if not Assigned(BuildingPersonnel.GetFirst()) then begin
     BuildingPersonnel.ReFill;
  end;
  CheckDepends(Sender as TWinControl);
  BuildingPersonnelVST.ReFill;
end;

procedure TMainForm.ShowServicesExecute(Sender: TObject);
begin
  ShowServicesList;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  MenuLabel.Checked:= not MenuLabel.Checked;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  if SpeedButton2.Caption = dspBtnCaptionLeft then begin
    Splitter3.Left:=SpeedButton2.Width;
    SpeedButton2.Caption:=dspBtnCaptionRight;
  end
  else begin
    Splitter3.Left:=cPanelWidth;
    SpeedButton2.Caption:=dspBtnCaptionLeft;
  end;
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  if SpeedButton3.Caption = dspBtnCaptionLeft then begin
    Splitter2.Left:=SpeedButton3.Width;
    SpeedButton3.Caption:=dspBtnCaptionRight;
  end
  else begin
    Splitter2.Left:=cPanelWidth;
    SpeedButton3.Caption:=dspBtnCaptionLeft;
  end;
end;

procedure TMainForm.SpeedButton4Click(Sender: TObject);
begin
  ServicesLabel.Checked:=False;
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  BuildingsLabel.Checked:=False;
end;

procedure TMainForm.SpeedButton6Click(Sender: TObject);
begin
  DateLabel.Checked:=False;
  BuildingsLabel.Checked:=False;
  ServicesLabel.Checked:=False;
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

procedure TMainForm.TabSheetShow(Sender: TObject);
begin
  if (not Conn.Connected) then exit;
  CheckDepends(Sender as TWinControl);
end;

procedure TMainForm.ToolButton3Click(Sender: TObject);
var
  xHTMLPanel: TMyIpHtmlPanel;
  xTabSheet: TTabSheet;
begin
  xTabSheet := CenterPageControl.AddTabSheet;
  xTabSheet.TabVisible:=True;
  xTabSheet.BringToFront;
  CenterPageControl.ActivePage:=xTabSheet;
  xHTMLPanel:=TMyIpHtmlPanel.Create(xTabSheet);
    xHTMLPanel.ShowHTML(
     '<HTML>'
    +'<head>'
//    +'<link rel="stylesheet" href="fpdoc.css" type="text/css">'
    + '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'
    +'</head>'
    +'<BODY>'
    +'<h1>MaCom</h1>'
    +'<p>Пример отчёта.</p>'
    +'</BODY></HTML>');
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
  if not AcceptDate then begin
     RefreshDates;
     exit;
  end;
  (Sender as TDateEdit).Date:=ADate;
  case (Sender as TDateEdit).Name of
    'WorkDateEdit': SaveWorkDate(WorkDateEdit.Date);
    else
      SaveWorkPeriod(WorkPeriodBeginEdit.Date, WorkPeriodEndEdit.Date);
  end;
end;

procedure TMainForm.WorkDateEditCustomDate(Sender: TObject; var ADate: string);
begin

end;

procedure TMainForm.WorkDateEditEditingDone(Sender: TObject);
begin
  case (Sender as TDateEdit).Name of
    'WorkDateEdit': SaveWorkDate(WorkDateEdit.Date);
    else
      SaveWorkPeriod(WorkPeriodBeginEdit.Date, WorkPeriodEndEdit.Date);
  end;
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

procedure TMainForm.WorksListChange(Sender: TBaseVirtualTree; Node: PVirtualNode
  );
begin

end;

procedure TMainForm.WorksListFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
//  MakeVSTLabel(WorksList, WorkVSTLabel);
  if not Assigned(WorkPageControl.ActivePage) then exit;
  WorkPageControl.ActivePage.OnShow(WorkPageControl.ActivePage);
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
  Log('Подключено: ' +Conn.UserName+'@'+Conn.HostName+'/'+Conn.DatabaseName);
  ConnectTabSheet.TabVisible:=False;

  SaveWorkDate(TDateTime(0));
  MainTreeFill;
  Log('Получение справочника домов...');
  BuildingsList.ReFill();
  Log('Получение справочника услуг...');
  ServicesList.ReFill();
  Log('Готово');

  ModesPanel.Visible:=True;
  MenuLabel.Checked:=True;

  LeftTabs.Enabled:=True;
  DateLabel.Checked:=True;

  BottomRollOut.Collapsed:=True;
  RefreshControlsBuildingsList(Self);
  RefreshControlsServicesList(Self);
  Cursor:=crDefault;

end;

procedure TMainForm.InitFormDisconnected;
var i: Integer;
begin
  if Conn.Connected then DBDisconnect(Conn);
  Log('Отключено');
  for i:=0 to CenterPageControl.PageCount-1 do
    CenterPageControl.Pages[i].TabVisible:=False;

  ModesPanel.Visible:=False;
  MenuLabel.Checked:=False;
  MenuSplitter.Position:=0;

  BuildingsList.Clear;
  RefreshControlsBuildingsList(Self);

  ServicesList.Clear;
  RefreshControlsServicesList(Self);

  ConnectTabSheet.TabVisible:=True;
  CenterPageControl.ActivePage:=ConnectTabSheet;
  LeftTabs.Enabled:=false;
  MainSplitter.Position:=0;
  BottomRollOut.Collapsed:=False;
end;

procedure TMainForm.Log(Note: String; Level: Integer);
begin
  if length(Note)>0 then begin
    LogView.Lines.Insert(0,'');
    LogView.Lines.Insert(0,DateTimeToStr(Now) + chr(9)+ Note);
  end;
//  LogView.SelStart:=Length(LogView.Text);
  BottomRollOut.Collapsed:=False;
  Application.ProcessMessages();
end;

procedure TMainForm.MakeVSTLabel(aVST: TDBVST; aLabel: TToggleBox; aPrefix: String = '');
begin
  if (not Conn.Connected) then exit;
  if aVST.SelectedCount>0 then begin
    if aVST.SelectedCount > 1 then
      aLabel.Caption:= aPrefix+'['+IntToStr(aVST.SelectedCount)+'] '
        + aVST.Text[aVST.FocusedNode, 0]
    else
      aLabel.Caption:=aPrefix+aVST.Text[aVST.FocusedNode, 0];
  end
  else begin
    aLabel.Caption:=aPrefix+dspNotAssigned;
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

