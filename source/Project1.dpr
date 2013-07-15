program Project1;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {FrmMain},
  LogFactory in 'lib\Svn\LogFactory.pas',
  SvnTypes in 'lib\Svn\SvnTypes.pas',
  Util in 'lib\Svn\Util.pas',
  NativeXml in 'lib\NativeXml310\NativeXml.pas',
  NativeXmlAppend in 'lib\NativeXml310\NativeXmlAppend.pas',
  NativeXmlObjectStorage in 'lib\NativeXml310\NativeXmlObjectStorage.pas',
  sdStringTable in 'lib\NativeXml310\sdStringTable.pas',
  NativeXmlHelper in 'lib\helper\NativeXmlHelper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
