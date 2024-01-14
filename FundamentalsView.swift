//
//  FundamentalsView.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import AVFoundation
import SwiftUI

struct FundamentalsView: View {
    @State private var selectedFundamental = "Filler Words"
    @State private var visitedFundamentals: Set<String> = []
    
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    
    
    let fundamentals = [ "Filler Words", "Rate of Speech", "Volume & Pitch", "Pauses"]
    
    var backgroundGradient = LinearGradient(colors: [.pink,.indigo, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
    @State private var animateFundGradient = false
    
    var body: some View {
        ZStack {
            
            backgroundGradient
                .ignoresSafeArea()
                .hueRotation(.degrees(animateFundGradient ? 0 : 45))
                .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: animateFundGradient)
                .onAppear {
                    withAnimation {
                        animateFundGradient.toggle()
                    }
                }
            
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
                    
                    if speechSynthesizer.isSpeaking {
                        speechSynthesizer.stopSpeaking(at: .immediate)
                    }
                    
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
                
                PracticeButtonView()
                    .padding()
                
                
            }
        }
    }
    
    
    @ViewBuilder
    private var fundamentalDetails: some View {
        switch selectedFundamental {
        case "Filler Words":
         //   Text("Become aware of filler words in your speech. Try to minimize them for a clearer and more concise message.")
            FillerWordsView(speechSynthesizer: $speechSynthesizer)
        case "Rate of Speech":
           // Text("Practice reading a passage at different speeds. Notice how the rate of your speech affects comprehension and audience engagement.")
            RateOfSpeechView(speechSynthesizer: $speechSynthesizer)
        case "Volume & Pitch":
           // Text("Experiment with different volumes and pitches. How does changing these elements impact the way your message is received?")
            VolumePitchView(speechSynthesizer: $speechSynthesizer)
        case "Pauses":
           // Text("Strategic pauses can add impact to your speech. Practice pausing after key points for effect.")
            PausesView(speechSynthesizer: $speechSynthesizer)
        default:
            EmptyView()
        }
    }
}


#Preview {
    FundamentalsView()
}


