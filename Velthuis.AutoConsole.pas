unit Velthuis.AutoConsole platform;

interface

implementation

uses
  Winapi.Windows;

function GetConsoleWindow: HWnd; stdcall;
  external 'kernel32.dll' name 'GetConsoleWindow';

procedure WaitForInput;
var
  InputRec: TInputRecord;
  NumRead: Cardinal;
  OldMode: DWORD;
  StdIn: THandle;
begin
  StdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(StdIn, OldMode);
  SetConsoleMode(StdIn, 0);
  repeat
    ReadConsoleInput(StdIn, InputRec, 1, NumRead);
  until (InputRec.EventType and KEY_EVENT <> 0) and InputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(StdIn, OldMode);
end;

function StartedFromConsole: Boolean;
var
  ConsoleHWnd: THandle;
  ProcessId: DWORD;
begin
  ConsoleHwnd := GetConsoleWindow;
  if ConsoleHWnd <> 0 then
  begin
    GetWindowThreadProcessId(ConsoleHWnd, ProcessId);
    Result := GetCurrentProcessId <> ProcessId;
  end
  else
    Result := False;
end;

procedure Pause;
begin
  if IsConsole and not StartedFromConsole then
  begin
    Writeln;
    Write('Press any key... ');
    WaitForInput;
  end;
end;

initialization

finalization
  Pause;

end.

