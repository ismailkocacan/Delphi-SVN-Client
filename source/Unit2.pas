// parameters:='/command:log /path:"D:\SAYE" /outfile:"C:\revisions.txt"  /startrev:6990 /endrev:7000 /closeonend:1';
// ShellExecute(0, nil, TortoiseProc, pchar(parameters), nil, SW_HIDE);

unit Unit2;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.Types,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  ShellApi,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Generics.Collections,

  Util,
  SvnTypes,
  LogFactory, Vcl.ImgList, Vcl.Menus;

type
  TFrmMain = class(TForm)
    lvLogs: TListView;
    mMessage: TMemo;
    Splitter1: TSplitter;
    images: TImageList;
    lvActions: TListView;
    Splitter2: TSplitter;
    mFiles: TMemo;
    Splitter3: TSplitter;
    sStatus: TStatusBar;
    PopupMenu1: TPopupMenu;
    ShowSQLFile1: TMenuItem;
    procedure lvLogsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure addLogsToListView(aLogs: TSvnLogList);
    procedure addActions(list: TList<TSvnFile>);
    procedure showLogDetail();
  end;

var
  FrmMain: TFrmMain;
  currentLog: TSvnLog;
  svnLog: TSvnLog;
  svnLogList: TSvnLogList;
  LogFactory: TSvnLogFactory;

const
  TortoiseProc = 'TortoiseProc.exe';

implementation

{$R *.dfm}

procedure TFrmMain.addActions(list: TList<TSvnFile>);
var
  aSvnFile: TSvnFile;
  item: TListItem;
begin
  lvActions.Clear;
  for aSvnFile in list do
  begin
    item := lvActions.Items.Add;
    item.Caption := aSvnFile.getName;
    item.SubItems.Add(aSvnFile.Path);
    item.SubItems.Add(aSvnFile.getAction);
  end;
end;

procedure TFrmMain.addLogsToListView(aLogs: TSvnLogList);
var
  item: TListItem;
begin
  lvLogs.Items.Clear;
  for svnLog in svnLogList do
  begin
    item := lvLogs.Items.Add;
    item.ImageIndex := -1;
    item.Caption := IntToStr(svnLog.Revision.revisionNo);
    item.SubItems.Add('');
    case svnLog.Revision.getActionList.Contains(Added) of
      True:
        item.SubItemImages[0] := 1;
      False:
        item.SubItemImages[0] := 0;
    end;
    item.SubItems.Add(svnLog.Author);
    item.SubItems.Add(svnLog.Date);
    item.SubItems.Add(svnLog.Message);
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
const
  SVN_CMD = 'svn log --xml --incremental -l50 -v D:\SAYE';
begin
  LogFactory := TSvnLogFactory.Create(SVN_CMD);
  svnLogList := LogFactory.getSvnLogs();
  addLogsToListView(svnLogList);
end;

procedure TFrmMain.lvLogsClick(Sender: TObject);
begin
  showLogDetail;
end;

procedure TFrmMain.showLogDetail();
var
  revNo: Integer;
  log: TSvnLog;

  afileList: TList<TSvnFile>;
  aSvnFile: TSvnFile;
begin
  if lvLogs.Items.Count = 0 then
    Exit;
  mMessage.Text := lvLogs.Selected.SubItems[3];
  revNo := StrToInt(lvLogs.Selected.Caption);
  log := findSvnLogByRevisionNo(svnLogList, revNo);
  case Assigned(log) of
    True:
      addActions(log.Revision.fileList);
    False:
      ShowMessage('bulunamadý');
  end;
  afileList := log.Revision.getFileList('.sql');
  for aSvnFile in afileList do
    mFiles.Lines.Add(aSvnFile.getName);
end;

end.
