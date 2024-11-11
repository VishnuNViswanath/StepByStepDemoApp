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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }.task {
            await healthStore.requestAuthorization()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
