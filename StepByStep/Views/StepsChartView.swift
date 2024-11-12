//
//  StepsChartView.swift
//  StepByStep
//
//  Created by Vishnu N Viswanath on 12/11/24.
//

import SwiftUI
import Charts

struct StepsChartView: View {
    
    let steps: [Step]
    
    var body: some View {
        Chart {
            ForEach(steps) { step in
                BarMark(x: .value("Date", step.date), y: .value("Count", step.count))
                    .foregroundStyle(isUnder8000(step.count) ? .red : .green)
            }
        }
    }
}

