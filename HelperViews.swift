//
//  HelperViews.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import SwiftUI
import Speech



struct HelperViews: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


struct StartButtonView: View {
    var body: some View {
        
        NavigationLink(destination: PracticeView()
            .navigationBarBackButtonHidden(true
                                          )) {
            HStack(spacing: 8) {
                Text("Get Started")
                    .foregroundColor(.primary)
                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(Color.green.opacity(0.5)) // Semi-transparent background
            )
        }
        .accentColor(Color.white)
    }
}

struct FundamentalsButtonView: View {
    @State private var showingAlert = false
    @State private var navigateToFunda = false

    var body: some View {
        NavigationLink(destination: FundamentalsView(), isActive: $navigateToFunda) {
            EmptyView()
        }

        Button(action: {
            requestSpeechPermission { authorized in
                if authorized {
                    self.navigateToFunda = true
                } else {
                    showingAlert = true
                }
            }
        }) {
            HStack(spacing: 8) {
                Text("Fundamentals")
                    .foregroundColor(.primary)
                Image(systemName: "info.bubble.fill")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.cyan.opacity(0.8)))
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Permission Required"), message: Text("Speech recognition permission is needed to use this feature."), dismissButton: .default(Text("OK")))
        }
        .accentColor(Color.white)
    }
}

struct PracticeButtonView: View {
    @State private var showingAlert = false
    @State private var navigateToPractice = false

    var body: some View {
        NavigationLink(destination: PracticeView(), isActive: $navigateToPractice) {
            EmptyView()
        }

        Button(action: {
            requestSpeechPermission { authorized in
                if authorized {
                    self.navigateToPractice = true
                } else {
                    showingAlert = true
                }
            }
        }) {
            HStack(spacing: 8) {
                Text("Practice")
                    .foregroundColor(.primary)
                Image(systemName: "person.wave.2")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color.green.opacity(0.8)))
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Permission Required"), message: Text("Speech recognition permission is needed to use this feature."), dismissButton: .default(Text("OK")))
        }
        .accentColor(Color.white)
    }
}

struct AnalysisCustomizationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var analyzeFillerWords: Bool
    @Binding var analyzeRateOfSpeech: Bool
    @Binding var analyzeVolume: Bool
    @Binding var analyzePitchAndMelody: Bool
    @Binding var analyzeTonality: Bool
    @Binding var analyzePause: Bool

    var body: some View {
        NavigationView {
            List {
                Toggle("Analyze Filler Words", isOn: $analyzeFillerWords)
                Text("Detect and analyze the use of non-essential words or sounds.")
                    .font(.caption)
                    .foregroundColor(.gray)

                Toggle("Analyze Rate of Speech", isOn: $analyzeRateOfSpeech)
                Text("Evaluate the speed at which you speak.")
                    .font(.caption)
                    .foregroundColor(.gray)

                Toggle("Analyze Volume", isOn: $analyzeVolume)
                Text("Assess the loudness or softness of your speech.")
                    .font(.caption)
                    .foregroundColor(.gray)

                Toggle("Analyze Pitch & Melody", isOn: $analyzePitchAndMelody)
                Text("Analyze the high and low tones in your speech.")
                    .font(.caption)
                    .foregroundColor(.gray)

                Toggle("Analyze Tonality", isOn: $analyzeTonality)
                Text("Examine the quality and emotion conveyed in your voice.")
                    .font(.caption)
                    .foregroundColor(.gray)

                Toggle("Analyze Pause", isOn: $analyzePause)
                Text("Look at the use and effectiveness of pauses in your speech.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .navigationBarTitle("Customize Analysis", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        })
        }
    }
}




func requestSpeechPermission(completion: @escaping (Bool) -> Void) {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        DispatchQueue.main.async {
            completion(authStatus == .authorized)
        }
    }
}

#Preview {
    HelperViews()
}
