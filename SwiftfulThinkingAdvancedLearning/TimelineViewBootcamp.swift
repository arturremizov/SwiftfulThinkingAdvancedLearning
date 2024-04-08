//
//  TimelineViewBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 7.04.24.
//

import SwiftUI

struct TimelineViewBootcamp: View {
    
    @State private var startDate: Date = .now
    @State private var pauseAnimation: Bool = false
    
    var body: some View {
        VStack {
            TimelineView(.animation(minimumInterval: 1, paused: pauseAnimation)) { context in
                Text("\(context.date)")
                Text("\(context.date.timeIntervalSince1970)")
                
//                let seconds = Calendar.current.component(.second, from: context.date)
                let seconds = context.date.timeIntervalSince(startDate)
                Text("\(seconds)")
                
                switch context.cadence {
                case .live:
                    Text("Cadence: Live")
                case .seconds:
                    Text("Cadence: seconds")
                case .minutes:
                    Text("Cadence: minutes")
                @unknown default:
                    fatalError()
                }
                
                Rectangle()
                    .frame(width: seconds < 10 ? 50 : seconds < 30 ? 200 : 400,
                           height: 100
                    )
                    .animation(.bouncy, value: seconds)
            }
            
            Button(pauseAnimation ? "Play" : "Pause") {
                pauseAnimation.toggle()
            }
        }
    }
}

#Preview {
    TimelineViewBootcamp()
}
