//
//  PracticeView.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import SwiftUI
import Speech

struct PracticeView: View {
    @State private var isRecording = false
    @State private var showCustomization = false
    
    @State private var showAnalysis = false
    @State private var loadingAnalysis = false
    
    @State private var speechAnalysisResult: String = ""
    @State private var transcriptResult = ""
    @ObservedObject var audioRecorder = AudioRecorder()
    
    // Additional states for analysis preferences can be added here
    
    var backgroundGradient = LinearGradient(colors: [.pink,.indigo, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing)
    @State private var animatePracGradient = false
    
    @State private var analyzeRateOfSpeech = true
    @State private var analyzePitch = true
    @State private var analyzePause = true
    
    var body: some View {
        ZStack {
            
            backgroundGradient
                .ignoresSafeArea()
                .hueRotation(.degrees(animatePracGradient ? 0 : 45))
                .animation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true), value: animatePracGradient)
                .onAppear {
                    withAnimation {
                        animatePracGradient.toggle()
                    }
                }
            
            VStack {
                Text("Practice Your Presentation Skill(z)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Record your speech on any topic, be it a prepared presentation or an impromptu talk. Get comfortable with public speaking.")
                    .padding()
                
                
                Text("Example Prompt: 'If you were to write a book, what genre would it be and what story would you tell?'")
                    .italic()
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                
                Text("Tip: A longer recording provides a more comprehensive analysis of your speaking style.")
                           .padding()
                
                
                // Record Button
                Button(action: {
                    if isRecording {
                        audioRecorder.stopRecording()
                        evaluateSpeech()
                    } else {
                        audioRecorder.startRecording()
                    }
                    isRecording.toggle()
                    // Add recording functionality here
                }) {
                    Image(systemName: isRecording ? "stop.circle" : "mic.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(isRecording ? .red : .green)
                }
                .padding()
                
                
                VolumeBarsView(audioRecorder: audioRecorder)
                    .padding()
                
                
                // Customize Analysis Button
                Button("Customize Analysis") {
                    showCustomization.toggle()
                    // Implement customization functionality
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showCustomization) {
                    AnalysisCustomizationView(analyzeRateOfSpeech: $analyzeRateOfSpeech,
                                              analyzePitch: $analyzePitch,
                                              analyzePause: $analyzePause)
                }
                .padding()
                
                
                if loadingAnalysis{
                    Text("Analyzing Your Speech...")
                        .padding()
                        .border(Color.teal, width: 1)
                    
                    ProgressView()
                }else{
                    Text("Your personalized feedback will be pop up after the analysis.")
                        .padding()
                        .border(Color.teal, width: 1)
                }
                
                
                Spacer()
            }
            .sheet(isPresented: $showAnalysis) {
                AnalysisResultView(analysisResult: $speechAnalysisResult, transcriptResult: $transcriptResult)
            }
            .padding()
            
            
        }
    }
    
    func evaluateSpeech() {
        loadingAnalysis = true
        guard let audioURL = audioRecorder.audioFileURL else { return }
        
        evaluateSpeech(from: audioURL) { result in
            switch result {
            case .success(let analysis):
                DispatchQueue.main.async {
  
                    var feedback = ""
                    
                    feedback += "Disclaimer: Speech analysis is subjective and can vary based on many factors such as context, content, individual speaking style, and cultural norms. The following insights are intended to guide and assist in personal speech development, not as definitive evaluations."
                    
                    
                    // Explanation for Filler Words
                        feedback += "\n\n• Filler Words: You used filler words \(analysis.fillerWordCount) times.\n"
                        feedback += analysis.fillerWordCount == 0 ? "This is great as it makes your speech clear and concise." : "Reducing these can make your speech more precise and impactful."
                        
                        // Explanation for Pitch Variation
                        if analyzePitch {
                            feedback += "\n\n• Pitch Variation: Your pitch varied between \(String(format: "%.2f", analysis.minPitch)) Hz and \(String(format: "%.2f", analysis.maxPitch)) Hz.\n"
                            feedback += "A varied pitch keeps the audience engaged by expressing emotions and emphasizing points."
                        }
                        
                        // Explanation for Rate of Speech
                        if analyzeRateOfSpeech {
                            feedback += "\n\n• Speech Rate Variation: \(String(format: "%.2f", analysis.rateOfSpeechVariation)).\n"
                            feedback += analysis.rateOfSpeechVariation > 1 ? "You vary your speaking rate well, which keeps the audience engaged." : "Your speaking rate is quite constant. Consider varying your speed for better engagement and emphasis."
                        }
                        
                        // Explanation for Pause Usage
                        if analyzePause {
                            feedback += "\n\n• Pause Usage: Your average pause length was \(String(format: "%.2f", analysis.averagePauseLength)) seconds.\n"
                            feedback += "Effective use of pauses allows key points to resonate with the audience and gives time for comprehension."
                        }
                    
                    self.speechAnalysisResult = feedback
                    self.transcriptResult = analysis.transcript
                    
                    loadingAnalysis = false
                    self.showAnalysis = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                     
                    self.speechAnalysisResult = "Please Try Recording Again. Error in analysis: \(error.localizedDescription)"
                    
                    self.loadingAnalysis = false
                    self.showAnalysis = true
                }
            }
        }
    }
    
    
    
    func evaluateSpeech(from audioFileURL: URL, completion: @escaping (Result<SpeechAnalysis, Error>) -> Void) {
        // Check for authorization and request if needed
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else {
                completion(.failure(SpeechEvaluationError.notAuthorized))
                return
            }
            
            let recognizer = SFSpeechRecognizer()
            let request = SFSpeechURLRecognitionRequest(url: audioFileURL)
            
            recognizer?.recognitionTask(with: request) { result, error in
                guard let result = result else {
                    completion(.failure(error ?? SpeechEvaluationError.unknown))
                    return
                }
                
                if result.isFinal {
                    // Perform custom analysis on the transcription
                    let analysis = analyzeTranscription(result.bestTranscription)
                    completion(.success(analysis))
                }
                
            }
        }
        
    }
    
    
}


#Preview {
    PracticeView()
}
