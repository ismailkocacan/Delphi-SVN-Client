unit SvnTypes;

interface

uses
  Util,
  TypInfo,
  Vcl.Dialogs,
  System.Types,
  System.SysUtils,
  System.StrUtils,
  Generics.Collections;

type

  TSvnAction = (Added, Modified, Removed);

  TSvnObject = class
  public
    class function createSvnAction(value: string): TSvnAction;
  protected
    function execCmd(commandLine: string): string;
  end;

  TSvnFile = class(TSvnObject)
  private
    fName: string;
    fPath: string;
    fAction: TSvnAction;
  public
    property Path: string read fPath write fPath;
    property Action: TSvnAction read fAction write fAction;
    function getAction: string;
    function getName: string;
  end;

  TSvnFileList = class(TList<TSvnFile>)

  end;

  TSvnRevision = class(TSvnObject)
  private
    fRevisionNo: Integer;
    fLineCount: Integer;
    fFileList: TList<TSvnFile>;
    fActionList: TList<TSvnAction>;
  public
    property RevisionNo: Integer read fRevisionNo write fRevisionNo;
    property LineCount: Integer read fLineCount write fLineCount;
    property FileList: TList<TSvnFile> read fFileList write fFileList;
    function getActionList: TList<TSvnAction>;
    function getFileList(fileExtension:string): TList<TSvnFile>;
  end;

  TSvnLog = class(TSvnObject)
  private
    fRevision: TSvnRevision;
    fAuthor: string;
    fDate: string;
    fMessage: string;
  public
    property Revision: TSvnRevision read fRevision write fRevision;
    property Author: string read fAuthor write fAuthor;
    property Date: string read fDate write fDate;
    property Message: string read fMessage write fMessage;
  end;

  TSvnLogList = class(TList<TSvnLog>)
  end;

function findSvnLogByRevisionNo(aInstance: TSvnLogList;
  aRevisionNo: Integer): TSvnLog;

implementation

{ TSvnObject }
class function TSvnObject.createSvnAction(value: string): TSvnAction;
var
  Action: TSvnAction;
begin
  if value = 'M' then
    Action := Modified;
  if value = 'A' then
    Action := Added;
  Result := Action;
end;

function TSvnObject.execCmd(commandLine: string): string;
begin
  Result := getDosOutput(commandLine, ExtractFilePath(ParamStr(0)));
end;

{ TSvnRevision }
function TSvnRevision.getActionList: TList<TSvnAction>;
var
  aSvnFile: TSvnFile;
begin
  fActionList := TList<TSvnAction>.Create;
  for aSvnFile in Self.FileList do
    fActionList.Add(aSvnFile.Action);
  Result := fActionList;
end;

function findSvnLogByRevisionNo(aInstance: TSvnLogList;
  aRevisionNo: Integer): TSvnLog;
var
  aSvnLog: TSvnLog;
  I: Integer;
begin
  Result := nil;
  for aSvnLog in aInstance do
  begin
    if (aSvnLog.Revision.RevisionNo = aRevisionNo) then
    begin
      Result := aSvnLog;
      Break;
    end;
  end;
end;

function TSvnRevision.getFileList(fileExtension: string): TList<TSvnFile>;
var
  aSvnFile: TSvnFile;
  sqlFileList: TList<TSvnFile>;
begin
  FreeAndNil(sqlFileList);
  sqlFileList := TList<TSvnFile>.Create;
  for aSvnFile in Self.FileList do
  begin
    if LowerCase(ExtractFileExt(aSvnFile.getName)) = Trim(fileExtension) then
      sqlFileList.Add(aSvnFile);
  end;
  Result := sqlFileList;
end;



{ TSvnFile }
function TSvnFile.getAction: string;
begin
  Result := GetEnumName(TypeInfo(TSvnAction), integer(Self.Action));
end;

function TSvnFile.getName: string;
var
  list: TStringDynArray;
begin
  list := SplitString(ExtractFileName(Self.Path), '/');
  Result := list[Length(list) - 1];
end;

end.
