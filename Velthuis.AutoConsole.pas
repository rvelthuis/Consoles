unit Velthuis.AutoConsole;

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
  OldKeyMode: DWORD;
  StdIn: THandle;
begin
  StdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(StdIn, OldKeyMode);
  SetConsoleMode(StdIn, 0);
  repeat
    ReadConsoleInput(StdIn, InputRec, 1, NumRead);
  until (InputRec.EventType and KEY_EVENT <> 0) and InputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(StdIn, OldKeyMode);
end;

function StartedFromConsole: Boolean;
var
  ConsoleHWnd: THandle;
  ProcessId: DWORD;
begin
  ConsoleHwnd := GetConsoleWindow;
  GetWindowThreadProcessId(ConsoleHWnd, ProcessId);
  Result := GetCurrentProcessId <> ProcessId;
end;

procedure Pause;
begin
  if IsConsole and not StartedFromConsole  then
  begin
    Write('Press any key... ');
    WaitForInput;
  end;
end;

initialization

finalization
  Pause;

end.
