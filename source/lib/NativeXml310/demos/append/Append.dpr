program Append;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  NativeXml in '..\..\NativeXml.pas',
  NativeXmlAppend in '..\..\NativeXmlAppend.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
