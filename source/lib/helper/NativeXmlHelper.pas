Unit NativeXmlHelper;

interface

uses NativeXml;

type

  TXmlNodeHelper = class helper for TXmlNode
  public
    function getValue: string;
  end;

implementation

{ TXmlNodeHelper }
function TXmlNodeHelper.getValue: string;
begin
  Result := UTF8ToString(Self.ValueAsUnicodeString);
end;

end.
