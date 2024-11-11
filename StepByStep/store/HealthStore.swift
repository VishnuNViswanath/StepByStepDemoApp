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
    var steps: [Step] = []
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            lastError = HealthError.noHealthDataAvailable
        }
    }
    
    func calculateSteps() async throws {
        guard let healthStore = self.healthStore else { return }
        
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(byAdding: .day, value: -7, to: Date())
        let endDate = Date()
        
        let stepType = HKQuantityType(.stepCount)
        let everyDay = DateComponents(day: 1)
        let thisWeek = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let stepsThisWeek = HKSamplePredicate.quantitySample(type: stepType, predicate: thisWeek)
        
        let sumOfStepsQuery = HKStatisticsCollectionQueryDescriptor(predicate: stepsThisWeek, options: .cumulativeSum, anchorDate: endDate, intervalComponents: everyDay)
        let stepCount = try await sumOfStepsQuery.result(for: healthStore)
        
        guard let startDate = startDate else { return }
        stepCount.enumerateStatistics(from: startDate, to: endDate) {
            statistics, stop in
            let count = statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0
            let step = Step(count: Int(count),date: statistics.startDate)
            
            if step.count > 0 {
                // add to steps collection
                self.steps.append(step)
            }
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


