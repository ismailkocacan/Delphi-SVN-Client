program XmlTest;

uses
  Forms,
  XmlTestMain in 'XmlTestMain.pas' {Form1},
  NativeXml in '..\..\NativeXml.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
