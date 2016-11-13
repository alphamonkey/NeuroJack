//
//  Perceptron.swift
//  NeuroJack
//
//  Created by Josh Edson on 11/12/16.
//  Copyright © 2016 Josh Edson. All rights reserved.
//

import Foundation


class Perceptron {
    var weights:[Double]
    var learningConstant = 0.1
    var inputs:[Double]!
    init(count:Int) {
        weights = []
        for _ in 0..<count {
            let weight = (Double(arc4random()) / Double(UINT32_MAX) * 2.0) - 1.0
            weights.append(weight)
        }
        
    }
    
    func feedForward(inputs:[Double]) -> Int {
      //  print(inputs)
      //  print(weights)
        self.inputs = inputs
        var sum:Double = 0.0

        for i in 0..<inputs.count {
            sum += Double(inputs[i]) * weights[i]
        }
        return activate(potential:sum)
    }
    func feedbackError(error:Int) {
        if(error) == 0 {
            return
        }
       
        for i in 0..<inputs.count {
            var newWeight = (Double(inputs[i]) * (Double(error))) * learningConstant
            
            weights[i] += newWeight

          
        }
    }
    func activate(potential:Double) -> Int {
     //   print(potential)
       
        if potential < 0.0 {
            return 0
        }
        else {
            return 1
        }
    }
}
