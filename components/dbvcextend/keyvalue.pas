unit keyvalue;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TKeyValue }

  TKeyValue = class
    private
      RowCode   : String;
      RowValue : String;

    public
      property Code : String
          read RowCode;
      property Value : String
          read RowValue;

      constructor Create(const aRowCode   : String;
                         const aRowValue : String);
  end;

  PKeyValue = ^TKeyValue;

  { TKeyValueList }

  TKeyValueList = class
    Items: array of TKeyValue;

    procedure Add(Item: TKeyValue);
    function Get(code: String): String;
    function Count(): Longint;
  end;

implementation

{ TKeyValueList }

procedure TKeyValueList.Add(Item: TKeyValue);
begin
  SetLength(Items, Length(Items) + 1);
  Items[Length(Items) - 1] := Item;
end;

function TKeyValueList.Get(code: String): String;
var
  i: Longint;
begin
  for i:=0 to (Length(Items)-1) do begin
    if (Items[i].Code = code) then begin
       Result:= Items[i].Value;
       exit;
    end;
  end;
  Result := '';
end;

function TKeyValueList.Count: Longint;
begin
  Result:= Length(Items);
end;

{ TKeyValue }

constructor TKeyValue.Create(const aRowCode: String; const aRowValue: String);
begin
  self.RowCode  := aRowCode;
  self.RowValue := aRowValue;
end;

end.

