//
//  Perceptron.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/12/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import Foundation

protocol NeuralInput {
    var charge:Double {get}
}

extension Perceptron:NeuralInput {
    
    var charge:Double {
        get {
            return Double(feedForward(inputs:inputs))
        }
    }
    
}
extension Double:NeuralInput {
    
    var charge:Double {
        return self
    }
}
class Perceptron {
    
    var weights:[Double]
    var learningConstant = 1.0
    var inputs:[NeuralInput]!
    var bias:Double = 0.5
    
    init(count:Int) {
        weights = []
        for _ in 0..<count + 1{
            let weight = (Double(arc4random()) / Double(UINT32_MAX) * 2.0) - 1.0
            weights.append(weight)
        }
        
    }
    func summedInputs() -> Double {
        var sum:Double = 0.0
        
        for i in 0..<inputs.count {
            sum += inputs[i].charge * weights[i]
        }
        sum += weights[inputs.count]
        return sum
    }
    
    func feedForward(inputs:[NeuralInput]) -> Double {

        self.inputs = inputs
        return activate(potential:summedInputs())
    
    }
    
    func feedbackError(error:Double) {
        
  
        for i in 0..<inputs.count {
            
            let newWeight = inputs[i].charge * error * learningConstant
            weights[i] += newWeight

        }
        
        // Add weighted bias
        let newWeight = bias * error * learningConstant
        weights[inputs.count] += newWeight
        
    }
    func activate(potential:Double) -> Double {

        if potential < 0.0 {
            return 0
        }
        else {
            return 1
        }
    }
}
