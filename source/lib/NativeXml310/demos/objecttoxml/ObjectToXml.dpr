program ObjectToXml;

uses
  Forms,
  ObjectToXmlMain in 'ObjectToXmlMain.pas' {Form1},
  NativeXml in '..\..\NativeXml.pas',
  NativeXmlObjectStorage in '..\..\NativeXmlObjectStorage.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
