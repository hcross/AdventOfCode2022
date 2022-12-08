def main():
  print("Day 8 with Python!")
  htrees = []
  f = open("./input")
  for line in f:
    htrees.append(list(line.strip()))
  vtrees = list(zip(*htrees))
  puzzle1(htrees, vtrees)
  puzzle2(htrees, vtrees)

def puzzle1(htrees, vtrees):
  visible_trees = len(htrees)*2+len(vtrees)*2-4
  for i,line in enumerate(htrees):
    for j,column in enumerate(vtrees):
      if i not in [0, len(htrees)-1] and j not in [0, len(vtrees)-1]:
        if is_visible(htrees[i], j) or is_visible(vtrees[j], i):
          visible_trees += 1
  print("Puzzle 1: {}".format(visible_trees))

def is_visible(arr, i):
  return all(k < arr[i] for k in arr[0:i]) or all(k < arr[i] for k in arr[i+1:len(arr)])

def puzzle2(htrees, vtrees):
  max = 0
  for i,line in enumerate(htrees):
    for j,column in enumerate(vtrees):
      if i not in [0, len(htrees)-1] and j not in [0, len(vtrees)-1]:
        scenic_score = scenic_score_1dim(htrees[j], i) * scenic_score_1dim(vtrees[i], j)
        if scenic_score > max:
          max = scenic_score
  print("Puzzle 2: {}".format(max))

def scenic_score_1dim(arr, i):
  left=0
  if i > 0:
    for k in reversed(arr[0:i]):
      left += 1
      if k >= arr[i]:
        break
  right=0
  if i < len(arr)-1:
    for k in arr[i+1:len(arr)]:
      right += 1
      if k >= arr[i]:
        break
  return left * right

if __name__ == "__main__":
    main()