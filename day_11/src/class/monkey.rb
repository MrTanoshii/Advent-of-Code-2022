##
# Base class for monkeys.
class Monkey

    ##
    # Constructor.
    #
    # @param id The id of the monkey.
    # @param itemList The list of items.
    # @param operand The operand to use.
    # @param operationValueList The list of values to use for the operation.
    # @param operationPosition The position of the operation.
    # @param divisibleTest The number to test for divisibility.
    # @param positiveMonkey The id of the monkey to send the item to if the item is divisible by the divisible test.
    # @param negativeMonkey The id of the monkey to send the item to if the item is not divisible by the divisible test.
    def initialize(id, itemList, operand, operationValueList, operationPosition, divisibleTest, positiveMonkey, negativeMonkey)
        @id = id
        @itemList = itemList
        @operand = operand
        @operationValueList = operationValueList
        @operationPosition = operationPosition
        @divisibleTest = divisibleTest
        @positiveMonkey = positiveMonkey
        @negativeMonkey = negativeMonkey
        @inspectionAmount = 0
    end

    ##
    # Getter for id.
    #
    # @return The id.
    def getId
        return @id
    end

    ##
    # Getter for the item list.
    #
    # @return The item list.
    def getItemList
        return @itemList
    end
    
    ##
    # Get the amount of inspections.
    #
    # @return The amount of inspections.
    def getInspectionAmount()
        return @inspectionAmount
    end

    ##
    # Get the divisible test.
    #
    # @return The divisible test.
    def getDivisibleTest()
        return @divisibleTest
    end

    ##
    # Add an item to the item list.
    #
    # @param item The item to add.
    def addItem(item)
        @itemList.push(item)
    end

    ##
    # Inspect the first item from the item list.
    #
    # @param divisor The divisor to use. Divides by 3 if divisor is less than or equal to 0.
    #
    # @return The worry level of the item. Can be nil.
    def inspectItem(divisor)
        @inspectionAmount += 1
        worryLevel = @itemList.shift()

        if (worryLevel.nil?)
            return nil
        end

        if (@operationValueList.length() == 2)
            worryLevel = performOperation(@operationValueList[0], @operand, @operationValueList[1])
        elsif (@operationValueList.length() == 1)
            if (@operationPosition == 0)
                worryLevel = performOperation(@operationValueList[0], @operand, worryLevel)
            else
                worryLevel = performOperation(worryLevel, @operand, @operationValueList[0])
            end
        else
            worryLevel = performOperation(worryLevel, @operand, worryLevel)
        end

        if (divisor > 0)
            return worryLevel % divisor
        end

        return worryLevel / 3
    end

    ##
    # Perform an operation on two numbers.
    #
    # @param num1 The first number.
    # @param operand The operand to use.
    # @param num2 The second number.
    #
    # @return The result of the operation.
    def performOperation(num1, operand, num2)
        num1 = Integer(num1)
        num2 = Integer(num2)

        if (operand == "+")
            return num1 + num2
        elsif (operand == "-")
            return num1 - num2
        elsif (operand == "*")
            return num1 * num2
        elsif (operand == "/")
            return num1 / num2
        end
    end

    ##
    # Get the id of the monkey to send the item to.
    #
    # @param worryLevel The worry level of the item.
    #
    # @return The id of the monkey to send the item to.
    def getMonkeyDestID(worryLevel)
        if (worryLevel % @divisibleTest == 0)
            return @positiveMonkey
        else
            return @negativeMonkey
        end
    end
end
