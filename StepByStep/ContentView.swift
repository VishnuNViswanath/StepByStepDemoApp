//
//  ContentView.swift
//  StepByStep
//
//  Created by Vishnu N Viswanath on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var healthStore = HealthStore()
    
    var body: some View {
        List(healthStore.steps) { step in
            Text("\(step.count)")
        }.task {
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
