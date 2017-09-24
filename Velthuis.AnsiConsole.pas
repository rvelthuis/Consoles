unit Velthuis.AnsiConsole;

// Replacement of some Console functions, using ANSI escape codes.

interface

const
  // ANSI escape code colors, not identical with codes in Console.pas!

  // Background and foreground colors
  Black        = 0;     // R=0, G=0, B=0
  Red          = 1;     // R=1, G=0, B=0
  Green        = 2;     // R=0, G=1, B=0
  Brown        = 3;     // R=1, G=1, B=0
  Blue         = 4;     // R=0, G=0, B=1
  Magenta      = 5;     // R=1, G=0, B=1
  Cyan         = 6;     // R=0, G=1, B=1
  LightGray    = 7;     // R=1, G=1, B=1

  // Foreground colors
  DarkGray     = 8;
  LightRed     = 9;
  LightGreen   = 10;
  Yellow       = 11;
  LightBlue    = 12;
  LightMagenta = 13;
  LightCyan    = 14;
  White        = 15;

procedure TextColor(Color: Integer);
procedure TextBackground(Color: Integer);
procedure GotoXY(X, Y: Integer);
function ReadKey: Char;
procedure ClrScr;

implementation

uses Posix.Termios;

const
  // Control sequence introducer for ANSI escape codes
  CSI = #27'[';
  CSBold = '1';
  CSNormal = '0';
  CSFGColor = '3';
  CSBGColor = '4';

procedure TextColor(Color: Integer);
begin
  Write(CSI);
  if Color > LightGray then
    Write(CSBold)
  else
    Write(CSNormal);
  Write(';', CSFGColor, (Color and $07), 'm');     // See constants above
end;

procedure TextBackground(Color: Integer);
begin
  Write(CSI);
  if Color > LightGray then
    Write(CSBold)
  else
    Write(CSNormal);
  Write(';', CSBGColor, (Color and $07), 'm');
end;

procedure GotoXY(X, Y: Integer);
begin
  Write(CSI, Y, ';', X, 'H');
end;

function ReadKey: Char;
var
  New, Old: Posix.Termios.termios;
begin
  tcgetattr(TTextRec(Input).Handle, Old);
  tcgetattr(TTextRec(Input).Handle, New);
  cfmakeraw(New);
  tcsetattr(TTextRec(Input).Handle, TCSANOW, New);
  Flush(Input);
  Read(Input, Result);
  tcsetattr(TTextRec(Input).Handle, TCSANOW, Old);
end;

procedure ClrScr;
begin
  Write(CSI, '2J');
  GotoXY(1, 1);
  TextBackground(Black);
end;

end.
