import strutils
import parseopt2
import bigints
import std/algorithm
import std/sequtils
import std/sugar

const
    C_MONKEY = "Monkey "
    C_STARTING_ITEMS = "  Starting items: "
    C_OPERATION = "  Operation: new = old "
    C_OLD = "old"
    C_TEST = "  Test: divisible by "
    C_TEST_IF_TRUE = "    If true: throw to monkey "
    C_TEST_IF_FALSE = "    If false: throw to monkey "

type
    Operator = enum oPlus, oMinus, oMult, oDiv
    Operation = tuple[operator: Operator, value: int, withOld: bool]
    TestType = enum tDivisible
    Item = tuple[interest: BigInt]
    Test = tuple
        testType: TestType
        value: int
        monkeyIfTrue: int
        monkeyIfFalse: int
    Monkey = object
        index: int
        manipulations: int
        items: seq[Item]
        operation: Operation
        test: Test

proc doOperation(input: BigInt, operation: Operation): BigInt =
    if operation.withOld:
        case operation.operator
        of oPlus:
            return input*2.initBigInt
        of oMinus:
            return 0.initBigInt
        of oMult:
            return input*input
        of oDiv:
            return 1.initBigInt
    else:
        case operation.operator
        of oPlus:
            return input + operation.value.initBigInt
        of oMinus:
            return input - operation.value.initBigInt
        of oMult:
            return input * operation.value.initBigInt
        of oDiv:
            return input div operation.value.initBigInt

proc parseOperator(c: string): Operator =
    case c
    of "+":
        return oPlus
    of "-":
        return oMinus
    of "*":
        return oMult
    of "/":
        return oDiv
    echo "Operator ${1} unknown, defaulting to '+' operator" % c
    return oPlus

proc getNextMonkey(item: Item, test: Test): int =
    if item.interest mod test.value.initBigInt == 0.initBigInt:
        return test.monkeyIfTrue
    else:
        return test.monkeyIfFalse

proc loadMonkeys(): seq[Monkey] =
    var m: seq[Monkey]
    var monkey: Monkey
    for line in lines("./input"):
        if line.startsWith(C_MONKEY):
            monkey = Monkey()
            monkey.index = parseInt(substr(line, C_MONKEY.len, line.len-2))
            monkey.manipulations = 0
        elif line.startsWith(C_STARTING_ITEMS):
            for item in split(substr(line, C_STARTING_ITEMS.len), ", "):
                monkey.items.add((interest: parseInt(item).initBigInt))
        elif line.startsWith(C_OPERATION):
            let ops = split(substr(line, C_OPERATION.len), " ")
            monkey.operation.operator = parseOperator(ops[0])
            if C_OLD == ops[1]:
                monkey.operation.withOld = true
            else:
                monkey.operation.withOld = false
                monkey.operation.value = parseInt(ops[1])
        elif line.startsWith(C_TEST):
            monkey.test.value = parseInt(substr(line, C_TEST.len))
            monkey.test.testType = tDivisible
        elif line.startsWith(C_TEST_IF_FALSE):
            monkey.test.monkeyIfFalse = parseInt(substr(line, C_TEST_IF_FALSE.len))
        elif line.startsWith(C_TEST_IF_TRUE):
            monkey.test.monkeyIfTrue = parseInt(substr(line, C_TEST_IF_TRUE.len))
        elif "" == line:
            m.add(monkey)
    m.add(monkey)
    return m

proc compareManipulations(a, b: Monkey): int =
    cmp(a.manipulations, b.manipulations)

proc puzzle1() =
    var monkeys = loadMonkeys()
    for i in 1..20:
        for monkey in mitems[Monkey](monkeys):
            var nitems: seq[Item]
            for item in mitems[Item](monkey.items):
                item.interest = doOperation(item.interest, monkey.operation) div 3.initBigInt
                monkey.manipulations += 1
                let nextMonkey = getNextMonkey(item, monkey.test)
                if nextMonkey == monkey.index:
                    nitems.add(item)
                else:
                    monkeys[nextMonkey].items.add(item)
            monkey.items = nitems
    monkeys.sort(compareManipulations)
    echo "Monkey business for puzzle 1 = ", monkeys[monkeys.high].manipulations * monkeys[monkeys.high-1].manipulations

proc puzzle2() =
    var monkeys = loadMonkeys()
    var commonMultiplicator = (monkeys.map(m => m.test.value).foldl(a*b)).initBigInt
    for i in 1..10000:
        for monkey in mitems[Monkey](monkeys):
            var nitems: seq[Item]
            for item in mitems[Item](monkey.items):
                item.interest = doOperation(item.interest, monkey.operation) mod commonMultiplicator
                monkey.manipulations += 1
                let nextMonkey = getNextMonkey(item, monkey.test)
                if nextMonkey == monkey.index:
                    nitems.add(item)
                else:
                    monkeys[nextMonkey].items.add(item)
            monkey.items = nitems
    monkeys.sort(compareManipulations)
    echo "Monkey business for puzzle 2 = ", monkeys[monkeys.high].manipulations * monkeys[monkeys.high-1].manipulations
puzzle1()
puzzle2()