import strutils as str

type
    Operator = enum oPlus, oMinus, oMult, oDiv
    Operation = tuple[operator: Operator, value: int]
    TestType = enum tDivisible
    Item = tuple[interest: int]
    Test = tuple
        testType: TestType
        value: int
        monkeyIfTrue: int
        monkeyIfFalse: int
    Monkey = object
        index: int
        items: seq[Item]
        operation: Operation
        test: Test

var
    monkeys: seq[Monkey]

proc loadMonkeys(): seq[Monkey] =
    var m: seq[Monkey]
    var monkey: Monkey
    var idx: int = 0
    for line in lines("./input"):
        if line.startsWith("Monkey"):
            monkey = Monkey()


monkeys = loadMonkeys()