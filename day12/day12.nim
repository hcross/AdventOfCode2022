import std/[sequtils, heapqueue, algorithm]

type
  Vector = (int, int)

const
  Infinity = high(int)
  LowestAltitude = ord('a')

var
  input = lines("./input").toSeq
  w = input[0].len
  h = input.len
  nbVectors = (h*w)-1

proc getSiblings(v: Vector): seq[Vector] =
  for (i,j) in @[(-1,0),(1,0),(0,-1),(0,1)]:
    let (x,y) = (v[0]+i,v[1]+j)
    if x in 0..w-1 and y in 0..h-1:
      result.add((x,y))

proc getHeight(v: Vector): int =
  let c: char = input[v[1]][v[0]]
  case c
  of 'S': ord('a')
  of 'E': ord('z')
  else: ord(c)

proc find(c: char): Vector =
  for j in 0..h-1:
    for i in 0..w-1:
      if input[j][i] == c: return (i,j)

# conversion from map to distance seq #
proc getIndex(v: Vector): int = v[0] + v[1]*w
proc getVector(index: int): Vector = (index mod w, index div w)

proc dijkstra(source: Vector): seq[int]=
  var
    distance = newSeq[int](w*h)
    previous = newSeq[int](w*h)
    queue = initHeapQueue[int]()
    sourceIndex = getIndex(source)

  # first init with start distance equal to 0 and infinity for the other spots
  distance[sourceIndex] = 0
  for v in 0..nbVectors:
    if v != sourceIndex:
      distance[v] = Infinity
      previous[v] = -1
    queue.push(v) # vectors(indexes) still to get through

  # main dijkstra algorithm
  while queue.len > 0:
    let
      p = queue.pop()
      (i,j) = getVector(p)
      h1 = getHeight((i,j))
    for (x,y) in getSiblings((i,j)):
      let h2 = getHeight((x,y))
      if h2 <= h1 + 1 and distance[p] < Infinity:
      # possible path found
        let
          alt = distance[p] + 1
          v = getIndex((x,y))
        if alt < distance[v]:
          distance[v] = alt
          previous[v] = p
          queue.push(v)

  distance

proc getStarts(): seq[Vector]=
  for j in 0..h-1:
    for i in 0..w-1:
      if LowestAltitude == getHeight((i,j)):
        result.add((i,j))

proc puzzle1() =
  let start = find('S')
  let finish = find('E')
  let d = dijkstra(start)
  let distanceToFinish = d[getIndex(finish)]
  echo "Puzzle 1: ", distanceToFinish

proc puzzle2() =
  var dists: seq[int]
  let finishIndex = getIndex(find('E'))
  for v in getStarts():
    dists.add(dijkstra(v)[finishIndex])
  dists.sort()
  echo "Puzzle 2: ", dists[0]

puzzle1()
puzzle2()
