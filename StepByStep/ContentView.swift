//
//  ContentView.swift
//  StepByStep
//
//  Created by Vishnu N Viswanath on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var healthStore = HealthStore()
    
    private var steps: [Step] {
        healthStore.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var body: some View {
        VStack {
            if let step = steps.first {
                TodayStepView(step: step)
            }
            StepListView(steps: Array(steps.dropFirst()))
        }
        .task {
            await healthStore.requestAuthorization()
            do {
                try await healthStore.calculateSteps()
            } catch {
                print(error)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
