//
//  FundamentalsView.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import SwiftUI

struct FundamentalsView: View {
    @State private var selectedFundamental = "Rate of Speech"
    @State private var visitedFundamentals: Set<String> = []
    let fundamentals = ["Rate of Speech", "Volume & Pitch", "Tonality & Melody", "Pauses", "Filler Words"]
    
    let backgroundGradient = LinearGradient(colors: [.pink,.cyan,.mint], startPoint: .topLeading, endPoint: .bottomTrailing)

    var body: some View {
        ZStack {
            backgroundGradient.ignoresSafeArea()

            VStack {
                Text("Voice Fundamentals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Picker("Select a Fundamental", selection: $selectedFundamental) {
                    ForEach(fundamentals, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedFundamental) { newValue in
                             visitedFundamentals.insert(newValue)
                         }

                         // Ensure the initial fundamental is added
                         .onAppear {
                             visitedFundamentals.insert(fundamentals.first ?? "")
                         }

                ProgressBar(value: visitedFundamentals.count, maxValue: fundamentals.count)
                    .frame(height: 20)
                    .padding()

                ScrollView {
                    VStack(alignment: .leading) {
                        fundamentalDetails
                    }
                    .padding()
                }

                Button("Ready to Practice All") {
                    // Action when user is ready to practice all fundamentals
                }
                .padding()
                .background(Capsule().fill(Color.green))
                .foregroundColor(.white)
            }
        }
    }


    @ViewBuilder
    private var fundamentalDetails: some View {
        switch selectedFundamental {
        case "Rate of Speech":
            Text("Practice reading a passage at different speeds. Notice how the rate of your speech affects comprehension and audience engagement.")
        case "Volume & Pitch":
            Text("Experiment with different volumes and pitches. How does changing these elements impact the way your message is received?")
        case "Tonality & Melody":
            Text("Your tone can convey emotion and emphasis. Practice varying your tonality to express different feelings or highlights.")
        case "Pauses":
            Text("Strategic pauses can add impact to your speech. Practice pausing after key points for effect.")
        case "Filler Words":
            Text("Become aware of filler words in your speech. Try to minimize them for a clearer and more concise message.")
        default:
            EmptyView()
        }
    }
}


#Preview {
    FundamentalsView()
}



struct ProgressBar: View {
    var value: Int
    let maxValue: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: 20)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Rectangle().frame(width: min(CGFloat(value) / CGFloat(maxValue) * geometry.size.width, geometry.size.width), height: 20)
                    .foregroundColor(Color.blue)
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
