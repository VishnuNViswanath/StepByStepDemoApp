//
//  HealthStore.swift
//  StepByStep
//
//  Created by Vishnu N Viswanath on 11/11/24.
//

import Foundation
import HealthKit
import Observation

enum HealthError: Error {
    case noHealthDataAvailable
}

@Observable
class HealthStore {
    var healthStore: HKHealthStore?
    var lastError: Error?
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.noHealthDataAvailable
        }
    }
    
    func requestAuthorization() async {
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
        guard let healthStore = self.healthStore else { return }
        do {
            try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        } catch {
            lastError = error
        }
        
            
    }
    
    
}


