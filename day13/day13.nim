import std/strutils
import std/algorithm
import std/strformat
import stacks

const
  LIST_START = '['
  LIST_END = ']'
  LIST_SEP = ','
  verbose = false

var
  DIVIDER_1 = "[[2]]"
  DIVIDER_2 = "[[6]]"

type
  Element = object
    leaf: bool
    value: int
    list: seq[Element]
  TrueBoolean = enum FALSE, TRUE, UNKNOWN

proc `!`(b: TrueBoolean): TrueBoolean =
  case b:
  of TRUE: FALSE
  of FALSE: TRUE
  of UNKNOWN: UNKNOWN

proc `&&`(a, b: TrueBoolean): TrueBoolean =
  if (a,b) in [(TRUE, FALSE), (FALSE, TRUE), (FALSE, UNKNOWN), (UNKNOWN, FALSE)]:
    FALSE
  elif (a,b) in [(TRUE, TRUE), (UNKNOWN, TRUE), (TRUE, UNKNOWN)]:
    TRUE
  else:
    UNKNOWN

proc `||`(a, b: TrueBoolean): TrueBoolean =
  if (a,b) in [(TRUE, FALSE), (FALSE, TRUE), (FALSE, UNKNOWN), (UNKNOWN, FALSE)]:
    FALSE
  elif (a,b) in [(TRUE, TRUE), (UNKNOWN, TRUE), (TRUE, UNKNOWN)]:
    TRUE
  else:
    UNKNOWN

proc `@`(b: bool): TrueBoolean =
  if b: return TRUE
  FALSE

proc isNumeric(c: char): bool =
  if '0' <= c and c <= '9': return true
  false

proc parse(line: string): Element =
  var s: Stack[Element]
  var buffer = ""
  for c in line:
    if LIST_START == c:
      if verbose: echo LIST_START
      s.push(Element(leaf: false))
    elif isNumeric(c):
      if verbose: echo "ALPHANUM ", c
      buffer.add(c)
    elif LIST_SEP == c or LIST_END == c:
      if buffer.len > 0:
        if verbose: echo "PARSE ", buffer
        var e = s.pop
        e.list.add(Element(leaf: true, value: parseInt(buffer)))
        buffer.setLen(0)
        s.push(e)
      if LIST_END == c:
        if verbose: echo LIST_END
        var inner = s.pop
        if s.len == 0:
          if verbose: echo "LAST LIST"
          return inner
        else:
          if verbose: echo "INNER PARENTHESIS"
          var outer = s.pop
          outer.list.add(inner)
          s.push(outer)
    else:
      echo "Error during parsing"
      return

proc `~>`(a,b: Element): TrueBoolean =
  if a.leaf and b.leaf:
    if verbose: echo a.value, " ~> ", b.value, " ? => ", a.value <= b.value
    if a.value < b.value: return TRUE
    elif a.value > b.value: return FALSE
    else: return UNKNOWN
  elif a.leaf:
    let newA = Element(leaf: false, list: @[a])
    return newA ~> b
  elif b.leaf:
    let newB = Element(leaf: false, list: @[b])
    return a ~> newB
  else:
    if b.list.len == 0 and a.list.len == 0:
      return UNKNOWN
    var comp = UNKNOWN
    for i in 0..max(a.list.high, b.list.high):
      if i > min(b.list.high, a.list.high):
        if i > b.list.high:
          return FALSE
        if i > a.list.high:
          return TRUE
      else :
        comp = a.list[i] ~> b.list[i]
        if comp != UNKNOWN:
          return comp
    return comp

proc toString(e: Element): string =
  if e.leaf:
    result.add(fmt"{e.value}")
  else:
    result.add(LIST_START)
    for i, sub in e.list:
      result.add(toString(sub))
      if i < e.list.high:
        result.add(LIST_SEP)
    result.add(LIST_END)

proc print(e: Element) =
  echo toString(e)

proc print(l: seq[Element]) =
  for e in l:
    print(e)

proc accumulateIndexedRighOrders(a, b: Element, index, value: int): int =
  result = value
  let comp = a ~> b
  if TRUE == comp:
    if verbose: echo "RIGHT ORDER"
    return value + index
  elif FALSE == comp:
    if verbose: echo "FALSE ORDER"
  else:
    if verbose: echo "SAME ORDER"

proc puzzle1() =
  var pairs: seq[Element]
  var acc = 0
  var i = 0
  for line in lines("./input"):
    if "" != line:
      if pairs.len == 0:
        if verbose: echo "------------------------------------"
        i += 1
      if verbose: echo line
      pairs.add(parse(line))
      if verbose: echo pairs[pairs.high]
    else:
      acc = accumulateIndexedRighOrders(pairs[0], pairs[1], i, acc)
      pairs = newSeq[Element]()
  acc = accumulateIndexedRighOrders(pairs[0], pairs[1], i, acc)
  echo "Puzzle 1: ", acc

proc puzzle2() =
  var packets: seq[Element]
  for line in lines("./input"):
    if "" != line:
      packets.add(parse(line))
  var divider1 = parse(DIVIDER_1)
  var divider2 = parse(DIVIDER_2)
  packets.add(divider1)
  packets.add(divider2)
  if verbose: print(packets)
  if verbose: echo "--------"
  packets.sort do (a, b: Element) -> int:
    case a ~> b:
    of TRUE: -1
    of FALSE: 1
    of UNKNOWN: 0
  if verbose: print(packets)
  var acc = 1
  for i, element in packets:
    if divider1 == element:
      if verbose: echo "Found div1 at position ", (i+1)
      acc *= i+1
    elif divider2 == element:
      if verbose: echo "Found div2 at position ", (i+1)
      acc *= i+1
  echo "Puzzle 2: ", acc

puzzle1()
puzzle2()