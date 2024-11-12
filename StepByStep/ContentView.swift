//
//  ContentView.swift
//  StepByStep
//
//  Created by Vishnu N Viswanath on 11/11/24.
//

import SwiftUI

enum DisplayType: Int, Identifiable, CaseIterable {
    
    case list
    case chart
    
    var id: Int {
        rawValue
    }
}

extension DisplayType {
    
    var icom: String {
        switch self {
        case .list:
            return "list.bullet"
        case .chart: 
            return "chart.bar"
        }
    }
}

struct ContentView: View {
    
    @State private var healthStore = HealthStore()
    @State private var displayType : DisplayType = .list
    
    private var steps: [Step] {
        healthStore.steps.sorted { lhs, rhs in
            lhs.date > rhs.date
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let step = steps.first {
                    TodayStepView(step: step)
                }
                
                Picker("Selection", selection: $displayType) {
                    ForEach(DisplayType.allCases) { displayType in
                        Image(systemName: displayType.icom).tag(displayType)
                    }
                }.pickerStyle(.segmented)
                
                switch displayType {
                case .list:
                    StepListView(steps: Array(steps.dropFirst()))
                case .chart:
                    Text("Chart View")
                }
                
                
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
            .navigationTitle("Step By Step")
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
