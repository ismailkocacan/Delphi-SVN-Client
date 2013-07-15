program XmlEditor;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  NativeXml in '..\..\NativeXml.pas',
  VirtualTrees in '..\..\..\..\extlib\VirtualTreeview_443\Source\VirtualTrees.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
