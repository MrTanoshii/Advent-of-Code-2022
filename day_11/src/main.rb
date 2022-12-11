require_relative './class/monkey.rb'

##
# Get the list of monkeys from the input file.
#
# @param inputFile The input file.
#
# @return The list of monkeys.
def getMonkeyList(inputFile)
    monkeys = []
    items = []
    operand = ""
    operationValueList = []
    isPositionSet = false
    operationPosition = -1

    line = inputFile.gets
    while (line)
        # Get monkey id
        line = getCleanedLine(line)
        id = Integer(line)
        # Get monkey items
        line = inputFile.gets
        line = getCleanedLine(line)
        line_split = line.split(' ')
        line_split.each { |item| items.push(Integer(item))}
        # Get operation
        line = inputFile.gets
        line = getCleanedLine(line)
        line_split = line.split(' ')
        line_split.each { |item| 
            if (item == "+" || item == "-" || item == "*" || item == "/")
                if (!isPositionSet)
                    operationPosition = 1
                    isPositionSet = true
                end
                operand = item
            else
                if (!isPositionSet)
                    operationPosition = 0
                    isPositionSet = true
                end
                operationValueList.push(Integer(item))
            end
        }
        # Get divisible test
        line = inputFile.gets
        line = getCleanedLine(line)
        divisibleTest = Integer(line)
        # Get positive monkey id
        line = inputFile.gets
        line = getCleanedLine(line)
        positiveMonkey = Integer(line)
        # Get negative monkey id
        line = inputFile.gets
        line = getCleanedLine(line)
        negativeMonkey = Integer(line)

        # puts "Opration Value list: #{operationValueList}"
        monkey = Monkey.new(id, items, operand, operationValueList, operationPosition, divisibleTest, positiveMonkey, negativeMonkey)
        monkeys.push(monkey)

        line = inputFile.gets
        line = inputFile.gets
        items = []
        operand = ""
        operationValueList = []
        isPositionSet = false
        operationPosition = -1
    end

    return monkeys
end

##
# Remove all characters except numbers from the line.
#
# @param line The line to clean.
#
# @return The cleaned line.
def getCleanedLine(line)
    line.tr!('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ:=,', '')
    return line
end

##
# Get the least common multiple of the monkey divisors
#
# @param monkeyList The list of monkeys.
#
# @return The least common multiple of the monkey divisors.
def getLCM(monkeyList)
    lcm = 1

    monkeyList.each { |monkey|
        lcm *= monkey.getDivisibleTest()
    }

    return lcm
end

# Get monkey data from the input file
inputFile = File.new(ARGV[0], "r")
if inputFile
    monkeyList = getMonkeyList(inputFile)
end
inputFile.close

roundAmount = Integer(ARGV[1])

# Check if the lcm should be calculated
if ARGV[2] == "true" || ARGV[2] == "True"
    lcm = getLCM(monkeyList)
else
    lcm = -1
end

# Run the rounds
for i in 1..roundAmount
    monkeyList.each { |monkey|
        for j in 0..monkey.getItemList.length() - 1
            worryLevel = monkey.inspectItem(lcm)
            monkeyList[monkey.getMonkeyDestID(worryLevel)].addItem(worryLevel)
        end
    }
end

# Print the monkey stats
inspectionAmounts = []
monkeyList.each { |monkey|
    puts "Monkey #{monkey.getId} has items: #{monkey.getItemList}"
    puts "         has inspected #{monkey.getInspectionAmount} items"
    inspectionAmounts.push(monkey.getInspectionAmount)
}

# Print the monkey business (Multiple the two highest inspection amounts)
inspectionAmounts.sort!
inspectionAmounts.reverse!
puts "Monkey business: #{inspectionAmounts.shift * inspectionAmounts.shift}"
