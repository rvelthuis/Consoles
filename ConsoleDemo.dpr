program ConsoleDemo;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Velthuis.Console in 'Velthuis.Console.pas';

const
  WinMargin = 5;

procedure WriteColor(const Text: string; Color: Byte);
var
  OldColor: Byte;
begin
  OldColor := TextColor;
  TextColor(Color);
  Write(Text);
  TextColor(OldColor);
end;

procedure Pause;
begin
  WriteColor('Press any key...', Yellow);
  ReadKey;
  Write(#13);
  ClrEol;
end;

procedure Caption(const Title: string);
begin
  Writeln(Title);
  Writeln(StringOfChar('-', Length(Title)));
  Writeln;
end;

//const
//  MainOctave: array[0..11] of Smallint = (
////  A    A+   B    C    C+   D    D+   E    F    F+   G    G+
//    440, 466, 493, 523, 554, 587, 622, 659, 698, 739, 783, 830);

procedure DemoSound;
begin
  Caption('Sound, Delay, NoSound demo');

  Writeln('This part of the demo will play a simple tune.');
  Writeln;
  Write('Press Esc key to skip, any other key to play...'#13);
  if Readkey <> #27 then
  begin
    Writeln('You should be hearing a well-known tune. If not, either your system');
    Writeln('does not support Sound as implemented in this unit, or Sound does');
    Writeln('not support your system, sorry.');
    Writeln;

    //  A    A+   B    C    C+   D    D+   E    F    F+   G    G+
    //  440, 466, 493, 523, 554, 587, 622, 659, 698, 739, 783, 830);

    // "Frère Jacques", "Are You Sleeping", "Vader Jacob", etc.
    // Note: I am not a musician. This is probably far from the original.

    Delay(400);

    Sound(523); Delay(400);
    Sound(587); Delay(400);
    Sound(659); Delay(400);
    Sound(523); Delay(200);
    NoSound; Delay(200);

    Sound(523); Delay(400);
    Sound(587); Delay(400);
    Sound(659); Delay(400);
    Sound(523); Delay(200);
    NoSound; Delay(200);

    Sound(659); Delay(400);
    Sound(698); Delay(400);
    Sound(783); Delay(600);
    NoSound; Delay(200);

    Sound(659); Delay(400);
    Sound(698); Delay(400);
    Sound(783); Delay(600);
    NoSound; Delay(200);

    Sound(783); Delay(200);
    Sound(880); Delay(200);
    Sound(783); Delay(200);
    Sound(698); Delay(200);
    Sound(659); Delay(400);
    Sound(523); Delay(200);
    NoSound; Delay(200);

    Sound(783); Delay(200);
    Sound(880); Delay(200);
    Sound(783); Delay(200);
    Sound(698); Delay(200);
    Sound(659); Delay(400);
    Sound(523); Delay(200);
    NoSound; Delay(200);

    Sound(523); Delay(400);
    Sound(391); Delay(400);
    Sound(523); Delay(600);
    NoSound; Delay(200);

    Sound(523); Delay(400);
    Sound(391); Delay(400);
    Sound(523); Delay(600);
    NoSound; Delay(200);

    Pause;
  end;
  ClrScr;
end;

procedure SetupWindow;
const
  BGString = 'Background ';
  WString = 'Window';
var
  I: Integer;
  J: Integer;
begin
  TextBackground(Blue);
  TextColor(LightBlue);
  ClrScr;
  Caption('Windowing demos');
  for I := 1 to ScreenHeight do
  begin
    GotoXY(1, I);
    for J := 1 to ScreenWidth div Length(BGString) do
      Write(BGString);
    if I < ScreenHeight then
      Write(BGString);
  end;
  Window(WinMargin, WinMargin,
         ScreenWidth - WinMargin + 1, ScreenHeight - WinMargin + 1);
  TextBackground(DarkGray);
  TextColor(White);
  ClrScr;
  GotoXY((ScreenWidth - Length(WString)) div 2 - WinMargin, 1);
  Write(WString);
  TextBackground(Black);
  Window(WinMargin + 1, WinMargin + 1,
         ScreenWidth - WinMargin, ScreenHeight - WinMargin);
  ClrScr;
end;

procedure DemoReadKey;
var
  C: Char;
begin
  Caption('ReadKey demo - press any number of keys - Esc ends');
  repeat
    C := ReadKey;
    case C of
      #0:
        begin
          C := ReadKey;
          Writeln('Extended: ', Ord(C));
        end;
      #12:
        begin
          ClrScr;
          GotoXy(4, 4);
        end;
      #27: Break;
      #$20..#$7E:
        Writeln('Normal: ''', C, ''' = Chr(', Ord(C), ')''');
      else
        Writeln('Normal: ', Ord(C));
    end;
  until C = #27;
  ClrScr;
end;

procedure DemoKeyPressed;
begin
  Caption('KeyPressed demo - any key press will stop this');
  repeat
    Write('.');
    Delay(20);
  until KeyPressed;
  ClrScr;
end;

procedure DemoXYFuncs;
begin
  Caption('Demonstrating GotoXY, WhereX, WhereY');
  Writeln('1234567890123456789012345678901234567890');
  Writeln('----.----+----.----+----.----+----.----+');
  Write('Demo text. WhereX = ');
  WriteColor(IntToStr(WhereX), Yellow);
  Write(', WhereY = ');
  WriteColor(IntToStr(WhereY), Yellow);
  Writeln;
  GotoXY(20, 10);
  WriteColor('This is at position (20,10)', LightRed);
  Writeln;
  Writeln;
  Pause;
end;

procedure DemoClrEol;
var
  OldBackground: Byte;
begin
  ClrScr;
  Caption('ClrEol demo');
  Write('This line is cleared to the end:');
  OldBackground := TextBackground;
  TextBackground(Red);
  ClrEol;
  TextBackground(OldBackground);
  Writeln;
  Writeln;
  Pause;
end;

procedure DemoInsLine;
var
  Y: Smallint;
  OldColor: Byte;
begin
  ClrScr;
  Writeln('InsLine demo');
  Writeln;
  Writeln('First line.');
  Y := WhereY;
  Writeln('Second line, a line will be inserted before this line.');
  Writeln('Third line.');
  Writeln;
  OldColor := TextColor;
  TextColor(Yellow);
  Write('Press any key...');
  TextColor(OldColor);
  GotoXY(8, Y);
  ReadKey;
  InsLine;
  ReadKey;
end;

procedure DemoDelLine;
var
  Y: Smallint;
  OldColor: Byte;
begin
  ClrScr;
  Caption('DelLine demo');
  Writeln('First line.');
  Y := WhereY;
  Writeln('Second line, this line will be deleted.');
  Writeln('Third line.');
  Writeln;
  OldColor := TextColor;
  TextColor(Yellow);
  Write('Press any key...');
  TextColor(OldColor);
  GotoXY(8, Y);
  ReadKey;
  DelLine;
  ReadKey;
end;

procedure DemoWriteln;
var
  I: Integer;
begin
  ClrScr;
  Caption('Write and Writeln with Window set');
  Writeln('This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window. ' +
          'This is a very very long string to demonstrate wrapping at ' +
          'the edge of the text window.');
  Writeln('Following are a few strings do demonstrate scrolling.');
  Pause;
  Writeln;
  for I := 1 to ScreenHeight - 2 * WinMargin - 3 do
    Writeln('Line #',I);
  Pause;
  ClrScr;
  for I := 0 to TextWindow.Right - TextWindow.Left do
    if I mod 8 = 0 then
      Write('+')
    else
      Write('.');
  Writeln('A'#9'string'#9'with'#9'a'#9'few'#9'tabs'#9'to'#9'see'#9'how'#9 +
          'they'#9'are'#9'handled.');
  Writeln;
  Write('A string with backspaces and a CRLF'#8#8' at the end. ' +
        'Press a key.'#13);
  ReadKey;
  Writeln('OVERWRITING THE SAME LINE... ');
  Writeln;
  Pause;
end;

begin
  Randomize;
  SetupWindow;
  DemoSound;
  DemoKeyPressed;
  DemoReadKey;
  DemoXYFuncs;
  DemoClrEol;
  DemoInsLine;
  DemoDelLine;
  DemoWriteln;
  Window(0, 0, 0, 0);
  NormVideo;
  ClrScr;
  Caption('End of demo');
  Pause;
end.
