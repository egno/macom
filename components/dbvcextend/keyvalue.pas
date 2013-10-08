unit keyvalue;

{
MaCom - Free/Libre Management Company Information System
Key-Value type unit

Copyright (C) 2013 Alexandr Shelemetyev
https://github.com/egno/macom

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/

Текст лицензии на русском: http://rusgpl.ru/
}

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

