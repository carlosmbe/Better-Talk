//
//  HelperViews.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import SwiftUI
import Speech


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
    
 
    @Binding var analyzeRateOfSpeech: Bool
    @Binding var analyzePitch: Bool
    @Binding var analyzePause: Bool

    var body: some View {
        NavigationView {
            List {
                Toggle("Analyze Rate of Speech", isOn: $analyzeRateOfSpeech)
                Text("Evaluate the speed at which you speak.")
                    .font(.caption)
                    .foregroundColor(.gray)


                Toggle("Analyze Pitch & Melody", isOn: $analyzePitch)
                Text("Analyze the high and low tones in your speech.")
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

/*Alternative ANAL
struct AnalysisResultView: View {
    @Binding var analysisResult: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                Text(analysisResult)
                    .padding()
                    .font(.system(size: 16))  // Set a suitable font size
                    .foregroundColor(.primary)  // Choose a suitable text color
            }
            .navigationTitle("Speech Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
 */

 
struct AnalysisResultView: View {
    @Binding var analysisResult: String
    @Environment(\.presentationMode) var presentationMode
    
    let titleGradient = LinearGradient(colors: [.pink,.cyan,.mint], startPoint: .bottomLeading, endPoint: .topTrailing)

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(analysisResult.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                }
                
                Text("Would You Like To Polish Up Those Fundamentals?")
                    .foregroundStyle(titleGradient)
                    .font(.title2)
                    .padding()
                
                FundamentalsButtonView()
                
                .padding()
            }
            .navigationTitle("Speech Analysis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Close")
                        .fontWeight(.semibold)
                }
            }
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

