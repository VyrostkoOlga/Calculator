//
//  Expression.swift
//  Calculator
//
//  Created by Ольга Выростко on 10.09.16.
//  Copyright © 2016 Ольга Выростко. All rights reserved.
//

import Foundation

class Operation : CustomStringConvertible {
    var operation: Character
    var priority: Int
    var call: ((Double...) -> Double)
    
    static let possibleOperations = Operation.createPossibleOperations()
    
    init?(strOperation: Character) {
        if (!Operation.isOperation(strOperation)) {
            return nil
        }
        
        self.operation = strOperation
        self.priority = Operation.possibleOperations[strOperation]!.priority
        self.call = Operation.possibleOperations[strOperation]!.call
    }
    
    var description : String {
        get {
            return String(self.operation)
        }
    }
    
    static private func createPossibleOperations() -> Dictionary<Character, (priority: Int, call: (Double...) -> Double)> {
        func doNothing(_ : Double...) -> Double {
            return -1;
        }
        
        func addFunc(operands: Double...) -> Double {
            return operands[0] + operands[1]
        }
        
        func subFunc(operands: Double...) -> Double {
            return operands[0] - operands[1]
        }
        
        func mulFunc(operands: Double...) -> Double {
            return operands[0] * operands[1]
        }
        
        func divFunc(operands: Double...) -> Double {
            return operands[0] / operands[1]
        }
        
        func remFunc(operands: Double...) -> Double {
            return operands[0] % operands[1]
        }
        
        return ["(" : (1, doNothing), ")" : (1, doNothing), "+" : (2, addFunc), "-" : (2, subFunc), "*" : (3, mulFunc), "/" : (3, divFunc), "%" : (3, remFunc)];
    }
    
    static func isOperation(strOperation: Character) -> Bool {
        return Operation.possibleOperations.keys.contains(strOperation)
    }
}

class Expression : CustomStringConvertible {
    var strExpression: String = ""
    var parsedExpression: Array<(operand: Double?, operation: Operation?)> = []
    
    init(expression: String) {
        self.strExpression = expression
        self.parse()
    }
    
    var description : String {
        get {
            var str : String = ""
            
            for el in self.parsedExpression {
                if el.operation != nil {
                    str.appendContentsOf("\(el.operation!) ")
                    continue
                }
                
                str.appendContentsOf("\(el.operand!) ");
            }
            
            str.appendContentsOf("= ")
            return str
        }
    }
    
    private func parse() {
        parsedExpression = []
        var stack: Array<Operation> = []
        self.parsedExpression = []
        
        var isInsideDigit = false
        var currentDigit = ""
        
        for characher in (self.strExpression.characters) {
            if Expression.isDigit(characher) {
                currentDigit.append(characher)
                isInsideDigit = isInsideDigit ? isInsideDigit: true
                continue
            }
            
            if (isInsideDigit) {
                self.parsedExpression.append((operand: Double(currentDigit), operation: nil))
                isInsideDigit = false
                currentDigit = ""
            }
            
            if (!Operation.isOperation(characher)) {
                continue
            }
            
            if characher == "(" {
                stack.append(Operation(strOperation: characher)!)
                continue
            }
            
            if characher == ")" {
                var stackOperation = stack.removeLast()
                while stackOperation.operation != "(" {
                    self.parsedExpression.append((operand: nil, operation: stackOperation))
                    stackOperation = stack.removeLast()
                }
                continue
            }
            
            let operation = Operation(strOperation: characher)!
            if (stack.isEmpty) {
                stack.append(operation)
                continue
            }
            
            var stackOperation = stack[stack.endIndex - 1]
            while !stack.isEmpty && stackOperation.priority >= operation.priority {
                self.parsedExpression.append((operand: nil, operation: stackOperation))
                stack.removeLast()
                stackOperation = stack[stack.endIndex - 1]
            }
            stack.append(operation)
        }
        
        if (isInsideDigit) {
            self.parsedExpression.append((operand: Double(currentDigit), operation: nil))
        }
        
        while (!stack.isEmpty) {
            self.parsedExpression.append((operand: nil, operation: stack.removeLast()))
        }
    }
    
    static private func isDigit(character: Character) -> Bool {
        return character >= "0" && character <= "9"
    }
}
