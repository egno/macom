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
  dbfunc, ExpandPanels, Grids, CheckLst, DbCtrls, FileCtrl, IniPropStorage,
  XMLPropStorage, Calendar, EditBtn, keyvalue, DBDynTreeView, ExtSQLQuery,
  DBVST, VirtualTrees;

type

  { TMainForm }

  TMainForm = class(TForm)
    ActionPanel3: TPanel;
    ActionPanel4: TPanel;
    ActionPanel5: TPanel;
    ActionSave: TAction;
    ActionDisconnect: TAction;
    ActionConnect: TAction;
    ActionPanel1: TPanel;
    ActionPanel2: TPanel;
    BuildingWorksSaveBtn: TBitBtn;
    BaseCB: TComboBox;
    BuildingPropertiesVST: TDBVST;
    IniPropStorage: TIniPropStorage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TabSheet2: TTabSheet;
    ToolButton4: TToolButton;
    WorkNameEdit: TMemo;
    WorkLabel: TLabel;
    WorkCondEdit: TMemo;
    WorkNote: TMemo;
    PageControl1: TPageControl;
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
    ServiceWorksList: TDBDynTreeView;
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
    BuildingContractWorksVST: TDBVST;
    WorkTabSheet: TTabSheet;
    TreeFilterEdit3: TTreeFilterEdit;
    WorkMainSaveBtn: TBitBtn;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    WorksTreeFilter: TTreeFilterEdit;
    WorkPairSplitter: TPairSplitter;
    PairSplitterSide3: TPairSplitterSide;
    PairSplitterSide5: TPairSplitterSide;
    PairSplitterSide6: TPairSplitterSide;
    ScrollBox2: TScrollBox;
    ServiceLabel: TLabel;
    BuildingsTreeView: TDBDynTreeView;
    SrvMainSaveBtn1: TBitBtn;
    SrvWorksSaveBtn: TBitBtn;
    Panel3: TPanel;
    Splitter2: TSplitter;
    BuildingTabSheet: TTabSheet;
    WorksTabSheet: TTabSheet;
    ToolButton3: TToolButton;
    TreeFilterEdit1: TTreeFilterEdit;
    TreeFilterEdit2: TTreeFilterEdit;
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
    WorksTreeView: TDBDynTreeView;
    ServicesTreeView: TDBDynTreeView;
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
    LeftAllTreeView: TTreeView;
    ConnectTabSheet: TTabSheet;
    ConnScrollBox: TScrollBox;
    ActionPanel: TPanel;
    ServiceTabSheet: TTabSheet;
    ServicePropMainTabSheet: TTabSheet;
    SrvWorksTabSheet: TTabSheet;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    WorksMainTreeView: TDBDynTreeView;
    procedure ActionConnectExecute(Sender: TObject);
    procedure ActionDisconnectExecute(Sender: TObject);
    procedure DataSave(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RefreshControl(C:String);
    procedure ServiceCompaniesVSTDblClick(Sender: TObject);
    procedure ServiceCompaniesVSTFocusChanged(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex);
    procedure ServicesTreeViewEnter(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure TreeViewSelectionChanged(Sender: TObject);
    procedure WorkAddBtnClick(Sender: TObject);
    procedure WorkDelBtnClick(Sender: TObject);
    procedure ExecSQL(SQL: String);
    function ReturnStringSQL(SQL: String): String;
    procedure FillListFromSQL(Items:TStrings ; SQL: String);
    procedure WorkFactorEditChange(Sender: TObject);
    procedure WorksTreeViewEnter(Sender: TObject);
  protected
  private
    procedure CheckConnected();
    procedure InitFormAfterConnect();
    procedure InitFormDisconnected();
    procedure Log(Note: String; Level: Integer = 0);
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


procedure TMainForm.DataSave(Sender: TObject);
var
  i, ib:Integer;
  VSTNode: PVirtualNode;
  VSTNodeData: PDBTreeData;
  bid, sid, wid: String;
  sql: String;
//  ServiceVSTNodeData: PDBTreeData;
begin
  case (Sender as TComponent).Name of
    'BuildingWorksSaveBtn': begin
      if (BuildingsTreeView.SelectionCount > 0)
              and Assigned(ServiceCompaniesVST.FocusedNode) then begin
        bid := '';
        for i:=0 to BuildingsTreeView.SelectionCount-1 do begin
          if bid > '' then bid := bid + ', ' ;
          bid := bid + '$$'
            + TKeyValue(BuildingsTreeView.Selections[i].Data).Code + '$$';
        end;
        sid := ServiceCompaniesVST.GetSelectedID();
        VSTNode := BuildingContractWorksVST.GetFirst();
        while VSTNode <> nil do begin
          VSTNodeData := BuildingContractWorksVST.GetNodeData(VSTNode);
          ExecSQL('update buildings_service_works set '
            + ' amount = 0' + VSTNodeData^[3] + ', '
            + ' amount_interval = $$' + VSTNodeData^[2] + '$$::interval '
            + ' where building in (' + bid + ') '
            + ' and service = $$' + sid +'$$ '
            + ' and work = $$' + VSTNodeData^[0] + '$$ ;'
            );
          VSTNode := BuildingContractWorksVST.GetNext(VSTNode);
        end;
      end;
      RefreshControl('BuildingContractWorksVST');
    end;
    'SrvWorksSaveBtn': begin
      ExecSQL('delete from service_works where '
        + ' service =  '
        + '''' + TKeyValue(ServicesTreeView.Selected.Data).Code + ''' '
        + ';'  );
      for i:=0 to ServiceWorksList.Items.Count-1 do begin
        if ServiceWorksList.Items[i].Data <> nil then
          ExecSQL('insert into service_works '
            + ' (service, work) '
            + ' values ( '
            + '''' + TKeyValue(ServicesTreeView.Selected.Data).Code + ''', '
            + '''' + TKeyValue(ServiceWorksList.Items[i].Data).Code + ''''
            + ');'  );
      end;
    end;
    'WorkMainSaveBtn': begin
      wid := '';
      sql := '';
      if (WorksMainTreeView.SelectionCount > 0) then begin
        wid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
        sql := sql + 'update works set ';
        if WorkCodeEdit.Text > '' then
          sql := sql + ' code = ' + '''' + WorkCodeEdit.Text + '''::ltree, '
        else
          sql := sql + ' code = NULL::ltree, ';
        if WorkNameEdit.Text > '' then
          sql := sql + ' disp = ' + '''' + WorkNameEdit.Text + ''', '
        else
          sql := sql + ' disp = NULL, ';
        if BaseCB.Text > '' then
          sql := sql + ' base = ' + '''' + BaseCB.Text + '''::ltree, '
        else
          sql := sql + ' base = NULL::ltree, ';
        if WorkFactorEdit.Text > '' then
          sql := sql + ' factor = ' + '''' + WorkFactorEdit.Text + '''::numeric, '
        else
          sql := sql + ' factor = NULL, ';
        if WorkCondEdit.Text > '' then
          sql := sql + ' condition = ' + '''' + WorkCondEdit.Text + ''' '
        else
          sql := sql + ' condition = NULL ';
        sql := sql + ' where id = '
            + '''' + wid + '''  '
            + ';';
        ExecSQL(sql);
      end;
    end;
  end;
end;



procedure TMainForm.FormShow(Sender: TObject);
begin
  DBDisconnect(Conn);
  CheckConnected();
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
  case C of
    'MainStatusBar': with (p as TStatusBar) do begin
      if Conn.Connected then begin
        Panels[0].Text:=Conn.UserName + '@'+ Conn.HostName + '/'
          + Conn.DatabaseName;
        Panels[1].Text:=ReturnStringSQL('select to_char(work_date(), '
          + '''' + sqlDateFormat + ''''
          + ') || '' '' || '
          + 'to_char(setting(''work.period'')::daterange, '''
          + sqlDateFormat
          + ''')');
      end
      else begin
        Panels[0].Text:=dspDisconnected;
        Panels[1].Text:='';
      end;
    end;
    'WorkResourcesVST': with (p as TDBVST) do
      if (WorksMainTreeView.SelectionCount > 0) then begin
        FillFromQuery(conn,
          'select id, false, resource_code::text, resource_disp, measure, amount from work_resources where work = '''
          + TKeyValue(WorksMainTreeView.Selected.Data).Code
          + ''' ',
          'null', '3', 1);
        Refresh;
      end
      else
        Clear;
    'ServiceCompaniesVST': with (p as TDBVST) do
      if (BuildingsTreeView.SelectionCount > 0) then begin
        FillFromQuery(conn,
          'select service, false, service_disp, company_disp from building_service_companies_complete where building = '''
          + TKeyValue(BuildingsTreeView.Selected.Data).Code
          + ''' ',
          'service_parent', '3', 2);
        Refresh;
      end
      else
        Clear;
      'BuildingPropertiesVST': with (p as TDBVST) do
        if (BuildingsTreeView.SelectionCount > 0) then begin
          FillFromQuery(conn,
            'select code::text, false, code::text, val from buildings_p where obj = '''
            + TKeyValue(BuildingsTreeView.Selected.Data).Code
            + ''' ',
            'null', '2', 1);
          Refresh;
        end
        else
          Clear;
    'ServiceWorksList': with (p as TDBDynTreeView) do
      if (ServicesTreeView.SelectionCount > 0) then begin
          FillFromQuery(conn,
            'SELECT work, work_full_disp FROM service_works '
           + ' where service = '''
           + TKeyValue(ServicesTreeView.Selected.Data).Code
           + ''''
           + ' and null ');
        end
      else
        Items.Clear;
    'BuildingBox': with (p as TGroupBox) do
      if (BuildingsTreeView.SelectionCount > 0) then begin
          Visible:=True;
          Caption:=TKeyValue(BuildingsTreeView.Selected.Data).Value;
        end
      else begin
        Caption:=dspNotAssigned;
        Visible:=False;
      end;
    'BuildingContractWorksVST': with (p as TDBVST) do
      if (BuildingsTreeView.SelectionCount > 0)
        and Assigned(ServiceCompaniesVST.FocusedNode) then begin
          VSTNodeData:=ServiceCompaniesVST.GetNodeData(
            ServiceCompaniesVST.FocusedNode);
          FillFromQuery(conn,
            'SELECT work, false, work_full_disp, amount_interval::text, amount FROM buildings_service_works '
           + ' where service = '''
           + VSTNodeData^[0]
           + ''''
           + ' and building = '''
           + TKeyValue(BuildingsTreeView.Selected.Data).Code
           + ''''
           + '  ',
           'null', '2');
        end
      else
        Clear;
    'ServicesWorkNote': with (p as TMemo) do begin
      tid := '';
      if (ActiveControl.Name = 'WorksTreeView') and
        (WorksTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksTreeView.Selected.Data).Code;
      if (ActiveControl.Name = 'ServiceWorksList') and
        (ServiceWorksList.SelectionCount > 0) then
          tid := TKeyValue(ServiceWorksList.Selected.Data).Code;
      if tid > '' then begin
        Json := TJSONParser.Create(ReturnStringSQL(
          'select note from works where id = '''
          + tid
          +''''));
        Text:=Json.Parse.FormatJSON([foDoNotQuoteMembers]);
      end
      else
        Text:='';
      end;
    'WorkNote': with (p as TMemo) do begin
      tid := '';
      if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Json := TJSONParser.Create(ReturnStringSQL(
          'select note from works where id = '''
          + tid
          +''''));
        Text:=Json.Parse.FormatJSON([foDoNotQuoteMembers]);
      end
      else
        Text:='';
      end;
    'WorkLabel': with (p as TLabel) do begin
      tid := ''; if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Caption:= ReturnStringSQL(
          'select code::text from works where id = '''
          + tid
          +'''');
      end
      else
        Text:='';
      end;
    'WorkNameEdit': with (p as TMemo) do begin
      tid := ''; if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Text:= ReturnStringSQL(
          'select disp from works where id = '''
          + tid
          +'''');
      end
      else
        Text:='';
      end;
    'WorkCodeEdit': with (p as TEdit) do begin
      tid := ''; if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Text:= ReturnStringSQL(
          'select code::text from works where id = '''
          + tid
          +'''');
      end
      else
        Text:='';
      end;
    'BaseCB': with (p as TComboBox) do begin
      tid := ''; if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Text:= ReturnStringSQL(
          'select base::text from works where id = '''
          + tid
          +'''');
      end
      else
        Text:='';
      end;
    'WorkFactorEdit': with (p as TEdit) do begin
      tid := ''; if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Text:= ReturnStringSQL(
          'select factor::text from works where id = '''
          + tid
          +'''');
      end
      else
        Text:='';
      end;
    'WorkCondEdit': with (p as TMemo) do begin
      tid := ''; if (WorksMainTreeView.SelectionCount > 0) then
          tid := TKeyValue(WorksMainTreeView.Selected.Data).Code;
      if tid > '' then begin
        Text:= ReturnStringSQL(
          'select condition::text from works where id = '''
          + tid
          +'''');
      end
      else
        Text:='';
      end;
  end;
  (p as TControl).Cursor:=crDefault;
end;

procedure TMainForm.ServiceCompaniesVSTDblClick(Sender: TObject);
begin
  ServiceCompaniesVST.EditNode(ServiceCompaniesVST.FocusedNode,
    ServiceCompaniesVST.FocusedColumn);
end;


procedure TMainForm.ServiceCompaniesVSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  case (Sender as TComponent).Name of
    'ServiceCompaniesVST': begin
//      RefreshControl('BuildingServiceBox');
//      RefreshControl('BuildingServiceWorksList');
      RefreshControl('BuildingContractWorksVST');
    end;
  end;
end;

procedure TMainForm.ServicesTreeViewEnter(Sender: TObject);
begin
//  SrvNameEdit.Text:=ServicesTreeView.Selected.Text;
end;

procedure TMainForm.ToolButton4Click(Sender: TObject);
begin
  MainForm.Cursor:=crHourGlass;
end;

procedure TMainForm.TreeViewSelectionChanged(Sender: TObject);
var
  Txt: String;
  Json: TJSONParser;
begin
  (Sender as TControl).Cursor:=crSQLWait;
  case (Sender as TComponent).Name of
    'ServicesTreeView': begin
      ServiceLabel.Caption:=(Sender as TDBDynTreeView).Selected.Text;
      SrvNameEdit.Text:=(Sender as TDBDynTreeView).Selected.Text;
      RefreshControl('ServiceWorksList');
    end;
    'WorksTreeView': begin
      RefreshControl('ServicesWorkNote');
    end;
    'WorksMainTreeView': begin
      RefreshControl('WorkLabel');
      RefreshControl('WorkNote');
      RefreshControl('WorkNameEdit');
      RefreshControl('WorkCodeEdit');
      RefreshControl('BaseCB');
      RefreshControl('WorkFactorEdit');
      RefreshControl('WorkCondEdit');
      RefreshControl('WorkResourcesVST');
    end;
    'ServiceWorksList': begin
        RefreshControl('ServicesWorkNote');
    end;
    'BuildingsTreeView': begin
      BuildingDetailsMemo.Clear;
      RefreshControl('BuildingBox');
      RefreshControl('ServiceCompaniesVST');
      RefreshControl('BuildingContractWorksVST');
      RefreshControl('BuildingPropertiesVST');
//      RefreshControl('BuildingServiceBox');
//      RefreshControl('BuildingServiceWorksList');
      if (Sender as TDBDynTreeView).SelectionCount > 0 then begin
        Txt:=ReturnStringSQL(
          'select note from buildings where id = '''
          + TKeyValue((Sender as TDBDynTreeView).Selected.Data).Code
          +'''');
        Json := TJSONParser.Create(Txt);
        BuildingDetailsMemo.Text:=Json.Parse.FormatJSON([foDoNotQuoteMembers]);
      end;
    end;
//    'BuildingServicesTreeView': RefreshControl(BuildingServiceCompany);
  end;
  (Sender as TControl).Cursor:=crDefault;
end;

procedure TMainForm.WorkAddBtnClick(Sender: TObject);
var
  i: Integer;
begin
  case (Sender as TComponent).Name of
    'WorkAddBtn': begin
      if WorksTreeView.Items.SelectionCount > 0 then
        for i := 0 to WorksTreeView.Items.SelectionCount-1 do
          ServiceWorksList.Items.AddObject(nil,
            WorksTreeView.Selections[i].Text,
            WorksTreeView.Selections[i].Data);

    end;
  end;
end;

procedure TMainForm.WorkDelBtnClick(Sender: TObject);
var
  i: Integer;
begin
  case (Sender as TComponent).Name of
    'WorkDelBtn': begin
      if ServiceWorksList.Items.SelectionCount > 0 then
        for i := ServiceWorksList.Items.SelectionCount-1 downto 0   do
          ServiceWorksList.Items.Delete(
            ServiceWorksList.Selections[i]);
    end;
  end;
end;

procedure TMainForm.ExecSQL(SQL: String);
var
  Query: TExtSQLQuery;
begin
  Query := TExtSQLQuery.Create(Self, Conn);
  try
    Query.SQL.Add(SQL);
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TMainForm.ReturnStringSQL(SQL: String): String;
var
  Query: TExtSQLQuery;
begin
  Query := TExtSQLQuery.Create(Self, Conn);
  try
    Query.SQL.Add(SQL);
    Query.Open;
    Result := Query.Fields[0].AsString;
  except
    Result := '';
  end;
  Query.Free;
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

procedure TMainForm.WorkFactorEditChange(Sender: TObject);
begin

end;

procedure TMainForm.WorksTreeViewEnter(Sender: TObject);
begin

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
  Log('Ждите...');
  Log('...получение справочника услуг');
  ServicesTreeView.FillFromQuery(Conn,
   'select id, disp from services_hlist where pid ') ;
//  BuildingServicesTreeView.FillFromQuery(Conn,
//   'select id, disp from services_hlist where parent ') ;

  Log('...получение справочника работ');
  WorksTreeView.FillFromQuery(Conn,
    'select id, full_disp from works where pid ');

  Log('...получение справочника работ');
  WorksMainTreeView.FillFromQuery(Conn,
    'select id, full_disp from works where pid ');

  Log('...получение справочника услуг');
  ServicesTreeView.FillFromQuery(Conn,
    'select id, disp from services where pid ');

  Log('...получение справочника домов');
  BuildingsTreeView.FillFromQuery(Conn,
    'select id, disp from buildings_hlist where pid ') ;

  Log('...получение справочника характеристик домов');
  FillListFromQuery(Conn, BaseCB.Items,
    'select code::text from building_prop_names ') ;

  Log('...получение справочника организаций');
//  FillListFromSQL(BuildingServiceCompany.Items,
//   'select uuid, disp from s_uk.dic_companies order by 2 ') ;

  Log('Готово');

  BuildingTabSheet.TabVisible:=True;
  CenterPageControl.ActivePage:=BuildingTabSheet;
  ConnectTabSheet.TabVisible:=False;
  Cursor:=crDefault;

end;

procedure TMainForm.InitFormDisconnected;
var i: Integer;
begin
  if Conn.Connected then DBDisconnect(Conn);
  Log('Отключено');
  ConnectTabSheet.TabVisible:=True;
  CenterPageControl.ActivePage:=ConnectTabSheet;
//  for i:=0 to CenterPageControl.PageCount-1 do
//    CenterPageControl.Pages[i].TabVisible:=False;
  ServicesTreeView.Items.Clear;
  WorksTreeView.Items.Clear;
end;

procedure TMainForm.Log(Note: String; Level: Integer);
begin
  if length(Note)>0 then
    LogView.Lines.Append(Note);
  LogView.SelStart:=Length(LogView.Text);
  Application.ProcessMessages();
end;

end.

