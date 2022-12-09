program day9;
{$MODE OBJFPC}

uses
  Sysutils,Strutils,Math;

const
  C_FNAME = './input';
  C_RIGHT = 'R';
  C_LEFT = 'L';
  C_UP = 'U';
  C_DOWN = 'D';
  verbose = false;

var
  inputFile: TextFile;
  s: string;
  delta: integer;
  hCount, hCountMin, hCountMax, vCount, vCountMin, vCountMax: integer;
  ropeX: array of integer;
  ropeY: array of integer;
  trail: array of array of boolean;
  n: integer;

function x(): integer;
begin
  x := ropeX[0];
end;

function y(): integer;
begin
  y := ropeY[0];
end;

function tx(): integer;
begin
  tx := ropeX[length(ropeX)-1];
end;

function ty(): integer;
begin
  ty := ropeY[length(ropeY)-1];
end;

procedure writePos();
begin
  write('HT:[',x(),',');
  write(y(),'][',tx());
  writeln(',',ty(),']');
end;

procedure writeTrailMap();
var
  i, j: integer;
begin
  for j:= length(trail[0])-1 downto 0 do
  begin
    for i:= 0 to length(trail)-1 do
    begin
      if trail[i][j] then
      begin
        write('#');
      end
      else
      begin
        write('.');
      end;
    end;
    writeln();
  end;
end;

procedure checkKnot(const hx, hy: integer; var tx, ty: integer);
var
  dx, dy: integer;
begin
  dx := hx-tx;
  dy := hy-ty;
  if (abs(dx) > 1) or (abs(dy) > 1) then
  begin
    if (tx <> hx) and (ty <> hy) then
    begin
      tx := tx+sign(dx);
      ty := ty+sign(dy);
    end
    else
    begin
      if tx = hx then
      begin
        ty := ty+sign(dy);
      end
      else
      begin
        if ty = hy then
        begin
          tx := tx+sign(dx);
        end
      end;
    end;
  end;
end;

procedure checkTrail();
var
  m: integer;
begin
  for m:=1 to length(ropeX)-1 do
  begin
    checkKnot(ropeX[m-1], ropeY[m-1], ropeX[m], ropeY[m]);
  end;
  trail[tx()][ty()] := true;
end;

procedure kmove(const toX, toY: integer; var fromX, fromY: integer);
var
  k: integer;
begin
  if verbose then
  begin
    write('move(', toX, ',');
    writeln(toY, ')');
  end;
  if fromX = toX then
    begin
      if verbose then
      begin
        write('movey:');
        writeln(fromY,'->',toY);
      end;
      if toY > fromY then
        begin
          for k:= fromY+1 to toY do
          begin
            fromY := k;
            checkTrail();
          end;
        end
      else
        begin
          for k:= fromY-1 downto toY do
          begin
            fromY := k;
            checkTrail();
          end;
        end;
    end
  else
    begin
      if fromY = toY then
        begin
          if verbose then
          begin
            write('movex:');
            writeln(fromX,'->',toX);
          end;
          if toX > fromX then
            begin
              for k:= fromX+1 to toX do
              begin
                fromX := k;
                checkTrail();
              end;
            end
          else
            begin
              for k:= fromX-1 downto toX do
              begin
                fromX := k;
                checkTrail();
              end;
            end;
        end;
    end;
end;

procedure move(const toX, toY: integer);
begin
  kmove(toX, toY, ropeX[0], ropeY[0]);
end;

function trailCount(): integer;
var
  i: integer;
  j: integer;
  count: integer;
begin
  count := 0;
  for i := 0 to length(trail)-1 do
  begin
    for j := 0 to length(trail[i])-1 do
    begin
      if trail[i][j] then
        count := count+1;
    end;
  end;
  trailCount := count;
end;

procedure preParseMovesInputFile();
var
  nbMoves: integer;
begin
  AssignFile(inputFile, C_FNAME);
  try
    writeln('Pre-parsing the moves input file');

    reset(inputFile);

    hCount := 0;
    vCount := 0;
    hCountMax := 0;
    vCountMax := 0;
    hCountMin := 0;
    vCountMin := 0;
    nbMoves := 0;

    while not eof(inputFile) do
    begin
      readln(inputFile, s);
      nbMoves := nbMoves + 1;
      delta := StrToInt(copy(s, 3, length(s)-1));
      case s[1] of
        C_LEFT  : hCount := hCount - delta;
        C_RIGHT : hCount := hCount + delta;
        C_UP    : vCount := vCount + delta;
        C_DOWN  : vCount := vCount - delta;
      else
        writeln('Unknown direction encountered');
      end;
      if hCount > hCountMax then
      begin
        hCountMax := hCount;
      end;
      if vCount > vCountMax then
      begin
        vCountMax := vCount;
      end;
      if hCount < hCountMin then
      begin
        hCountMin := hCount;
      end;
      if vCount < vCountMin then
      begin
        vCountMin := vCount;
      end;
    end;

    write('h(min,max):',hCountMin,',');
    writeln(hCountMax);
    write('v(min,max):',vCountMin,',');
    writeln(vCountMax);

    CloseFile(inputFile);

    writeln('Parsing done.');
    writeln(nbMoves, ' move operations found.');
    write('Playfield size calculation results: [', hCountMax+1, ',');
    writeln(vCountMax+1, '].');

  except
    on E: EInOutError do
      writeln('Error reading input file. Details: ', E.Message);
  end;
end;

procedure puzzleN(puzzleIndex, nbKnots: integer);
begin
  writeln('Processing file for tail travel simulation');
  setLength(trail, abs(hCountMax-hCountMin)+1, abs(vCountMax-vCountMin)+1);
  setLength(ropeX, nbKnots);
  setLength(ropeY, nbKnots);

  AssignFile(inputFile, C_FNAME);
  try
    for n:= 0 to length(ropeX)-1 do
    begin
      ropeX[n] := -hCountMin;
      ropeY[n] := -vCountMin;
    end;
    trail[x()][y()] := true;
    if verbose then
      writePos();

    reset(inputFile);
    while not eof(inputFile) do
    begin
      readln(inputFile, s);
      delta := StrToInt(copy(s, 3, length(s)-1));
      if verbose then
      begin
        writeln('---');
        writeln(s[1],' ',delta);
      end;
      case s[1] of
        C_LEFT  : move(x() - delta, y());
        C_RIGHT : move(x() + delta, y());
        C_UP    : move(x(), y() + delta);
        C_DOWN  : move(x(), y() - delta);
      else
        writeln('Unknown direction encountered');
      end;
    end;

    if verbose then
      writeTrailMap();

    CloseFile(inputFile);

    writeln('Simulation done.');
    write('Tail trail count for puzzle ', puzzleIndex , ': ');
    writeln(trailCount());

  except
    on E: EInOutError do
      writeln('Error reading input file. Details: ', E.Message);
  end;

  setLength(trail, 0, 0);
  setLength(ropeX, 0);
  setLength(ropeY, 0);
end;

procedure puzzle1();
begin
  puzzleN(1, 2);
end;

procedure puzzle2();
begin
  puzzleN(2, 10);
end;

begin
  writeln ('Day 9 with pascal');
  preParseMovesInputFile();
  puzzle1();
  puzzle2();
end.