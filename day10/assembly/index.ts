// The entry file of your WebAssembly module.

const ADDX: string = 'addx';
const NOOP: string = 'noop';
const ticks: i32[] = [ 20, 60, 100, 140, 180, 220 ];
const ticks2: i32[] = [ 40, 80, 120, 160, 200, 240 ];
const verbose: boolean = false;

function getTimedInput(input: string[]): string[] {
  let timed: string[] = new Array<string>();
  for (let i: i32 = 0; i < input.length; i++) {
    let line: string = input[i];
    let op: string = line.split(' ')[0];
    if (NOOP === op) {
      timed.push(line);
    } else if (ADDX === op) {
      timed.push('addx 0');
      timed.push(line);
    } else {
      console.error('Unknown operand encountered: ' + op);
    }
  };
  return timed;
}

function isLit(acc: i32, crtX: i32): boolean {
  return crtX >= acc-1 && crtX <= acc+1;
}

export function puzzle2(input: string[]): i32 {
  let timed: string[] = getTimedInput(input);
  let screen: string[] = new Array<string>(6);

  var acc :i32 = 1;
  var crtX: i32 = 1;
  var crtLine: string = "#";
  for (let i: i32 = 0; i < timed.length; i++) {
    let words: string[] = timed[i].split(' ');

    if (ticks2.indexOf(i+1) != -1) {
      console.log(crtLine);
      crtX=0;
      crtLine = "";
    }

    let op: string = words[0];
    if (NOOP === op) {
    } else if (ADDX === op) {
      var value: i32 = i32(parseInt(words[1]));
      acc += value;
    } else {
      console.error('Unknown operand encountered ' + op);
    }

    if (isLit(acc, crtX))
      crtLine = crtLine + '#';
    else
      crtLine = crtLine + '.';

    if (verbose) console.debug('(' + (i+1).toString() + ') Instructions: '
      + timed[i] + ', Register: ' + acc.toString());

    crtX++;
  };
  console.log('');
  return 0;
}

export function puzzle1(input: string[]): i32 {
  let timed: string[] = getTimedInput(input);
  
  var acc :i32 = 1;
  var signal :i32 = 0;
  for (let i: i32 = 0; i < timed.length; i++) {
    let words: string[] = timed[i].split(' ');

    if (ticks.indexOf(i+1) != -1) {
      if (verbose) console.debug('Signal added +' + (acc * (i+1)).toString());
      signal += acc * (i+1);
    }

    let op: string = words[0];
    if (NOOP === op) {
    } else if (ADDX === op) {
      var value: i32 = i32(parseInt(words[1]));
      acc += value;
    } else {
      console.error('Unknown operand encountered ' + op);
    }
    if (verbose) console.debug('(' + (i+1).toString() + ') Instructions: '
      + timed[i] + ', Register: ' + acc.toString() + ', Signal: ' + signal.toString());
  };
  return signal;
}
