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
    
    let fillerWord = false
    @Binding var analyzeRateOfSpeech: Bool
    @Binding var analyzePitch: Bool
    @Binding var analyzePause: Bool

    var body: some View {
        NavigationView {
            List {
                    
                
                Text("Filler Words")
                
                Text("Looking for: um, uh, like, you know, so, actually, basically, I mean")
                    .font(.caption)
                    .foregroundColor(.gray)
                
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

 
struct AnalysisResultView: View {
    @Binding var analysisResult: String
    
    @Binding var transcriptResult: String
    
    @State private var showTranscript = false
    
    @Environment(\.presentationMode) var presentationMode

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
                    
                    Toggle("Would You Like To See a Transcript of Your Recording?", isOn: $showTranscript)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(10)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    
                    if showTranscript{
                        Text("Trasncript: \(transcriptResult)")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(10)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    
                    HStack{
                        Text("Would You Like To Polish Up Those Fundamentals?  ")
                            .font(.title2)
                        
                        FundamentalsButtonView()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    
                    
                }.background(Color.clear)
                    
                
            }
            
            .background(LinearGradient(colors: [.clear,.indigo, .accentColor, .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
            
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



struct GlassModifier: ViewModifier {
    let cornerRadius: CGFloat
    let fill: Color
    let opacity: CGFloat
    let shadowRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background {
                GlassView(cornerRadius: cornerRadius, fill: fill, opacity: opacity, shadowRadius: shadowRadius)
            }
    }
}

extension View {
    func glass(cornerRadius: CGFloat, fill: Color = .white, opacity: CGFloat = 0.25, shadowRadius: CGFloat = 10.0) -> some View {
        modifier(GlassModifier(cornerRadius: cornerRadius, fill: fill, opacity: opacity, shadowRadius: shadowRadius))
    }
}

struct GlassView: View {
    let cornerRadius: CGFloat
    let fill: Color
    let opacity: CGFloat
    let shadowRadius: CGFloat

    init(cornerRadius: CGFloat, fill: Color = .white, opacity: CGFloat = 0.25, shadowRadius: CGFloat = 10.0) {
        self.cornerRadius = cornerRadius
        self.fill = fill
        self.opacity = opacity
        self.shadowRadius = shadowRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(fill)
            .opacity(opacity)
            .shadow(radius: shadowRadius)
    }
}
