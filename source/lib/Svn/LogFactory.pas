{
  // http://stackoverflow.com/questions/8354658/how-to-create-xml-file-in-delphi
  // http://stackoverflow.com/questions/1532353/issue-building-an-xml-document-using-txmldocument
  // http://stackoverflow.com/questions/8398703/delphi-txmldocument-created-at-run-time-generates-av-with-component-on-the-fo
}
unit LogFactory;

interface

uses
  NativeXml,
  NativeXmlHelper,
  SvnTypes,
  Vcl.Forms,
  Vcl.Dialogs,
  System.Types,
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  Generics.Collections;
type

  TSvnLogFactory = class(TSvnObject)
  private
    fSvnCommand: string;
    flogCmdOutput: string;
    flogXml: TStrings;
    fSvnLogList: TSvnLogList;
    fXmlDocument: TNativeXml;
  public
    function getSvnLogs(): TSvnLogList;
    constructor Create(svnCommand: string); overload;
  end;

implementation

{ TSvnLogFactory }
constructor TSvnLogFactory.Create(svnCommand: string);
begin
  fSvnCommand := svnCommand;
  fSvnLogList := TSvnLogList.Create;
end;

function TSvnLogFactory.getSvnLogs(): TSvnLogList;

var
  i, j: Integer;
  aSvnFile: TSvnFile;
  aSvnLog: TSvnLog;
  aSvnRevision: TSvnRevision;
  nLogs, nLogEntry, nAuthor, nDate, nPaths, nPath, nMsg: TXmlNode;
const
  XML_HEADER = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';
begin
  flogCmdOutput := execCmd(fSvnCommand);
  flogXml := TStringList.Create;
  flogXml.Insert(0, XML_HEADER);
  flogXml.Add('<logs>');
  flogXml.Add(flogCmdOutput);
  flogXml.Add('</logs>');

  fXmlDocument := TNativeXml.Create;
  fXmlDocument.XmlFormat := xfReadable;
  fXmlDocument.ReadFromString(Trim(flogXml.Text));

  fSvnLogList := TSvnLogList.Create;
  nLogs := fXmlDocument.Root;
  for i := 0 to nLogs.NodeCount - 1 do
  begin
    nLogEntry := nLogs.Nodes[i];
    nAuthor := nLogEntry.NodeByName('author');
    nDate := nLogEntry.NodeByName('date');
    nMsg := nLogEntry.NodeByName('msg');
    nPaths := nLogEntry.NodeByName('paths');

    aSvnLog := TSvnLog.Create;
    aSvnLog.Author := nAuthor.getValue;
    aSvnLog.Date := nDate.getValue;
    aSvnLog.Message := nMsg.getValue;

    aSvnRevision := TSvnRevision.Create;
    aSvnRevision.FileList := TList<TSvnFile>.Create;
    aSvnRevision.RevisionNo := StrToInt(nLogEntry.AttributeByName['revision']);

    for j := 0 to nPaths.NodeCount - 1 do
    begin
      nPath := nPaths.Nodes[j];
      aSvnFile := TSvnFile.Create;
      aSvnFile.Path := nPath.getValue;
      aSvnFile.Action := TSvnObject.createSvnAction(nPath.AttributeByName['action']);
      aSvnRevision.FileList.Add(aSvnFile);
    end;
    aSvnLog.Revision := aSvnRevision;
    fSvnLogList.Add(aSvnLog);
  end;
  Result := fSvnLogList;
end;



end.
