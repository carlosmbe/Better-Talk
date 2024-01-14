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
    
    @State private var speechAnalysisResult: String = ""
    @ObservedObject var audioRecorder = AudioRecorder()
    
    // Additional states for analysis preferences can be added here
    
    let backgroundGradient = LinearGradient(colors: [.pink,.cyan,.mint], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    @State private var analyzeFillerWords = true
    @State private var analyzeRateOfSpeech = true
    @State private var analyzePitch = true
    @State private var analyzePause = true
    
    var body: some View {
        ZStack {
            
            backgroundGradient.ignoresSafeArea()
            
            VStack {
                Text("Practice Your Presentation Skill(z)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                Text("You can talk about anything you want, practice a prepared speech, or answer an open-ended question.")
                    .padding()
                
                
                Text("Here's an example, If you could write a book, what genre and story would you choose to explore?")
                    .italic()
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                
                Text("The longer the recording, the better the evaluation")
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
                    AnalysisCustomizationView(analyzeFillerWords: $analyzeFillerWords,
                                              analyzeRateOfSpeech: $analyzeRateOfSpeech,
                                              analyzePitch: $analyzePitch,
                                              analyzePause: $analyzePause)
                }
                .padding()
                
                
                
                Text("Feedback will magically pop up after analysis")
                    .foregroundColor(.gray)
                    .padding()
                    .border(Color.gray, width: 1)
                
                
                Spacer()
            }
            .sheet(isPresented: $showAnalysis) {
                AnalysisResultView(analysisResult: $speechAnalysisResult)
            }
            .padding()
            
            
        }
    }
    
    func evaluateSpeech() {
        guard let audioURL = audioRecorder.audioFileURL else { return }
        
        evaluateSpeech(from: audioURL) { result in
            switch result {
            case .success(let analysis):
                DispatchQueue.main.async {
                    
                    var resultString = "Speech Analysis:\n\n"  // Added extra line break
                    
                    resultString += "Disclaimer: Speech analysis is subjective and can vary based on many factors such as context, content, individual speaking style, and cultural norms. The following insights are intended to guide and assist in personal speech development, not as definitive evaluations.\n\n"


                    // Filler Words
                    resultString += "• Filler Words: You used filler words \(analysis.fillerWordCount) times.\n"
                    resultString += analysis.fillerWordCount == 0 ? "  - Nice! Minimizing these makes your speech clearer.\n\n" : "  - Try to minimize these to make your speech clearer.\n\n"

                    /*/ Average Pitch
                    resultString += "• Pitch Variation: Your pitch variation was \(String(format: "%.2f", analysis.averagePitch)).\n"
                    resultString += analysis.averagePitch > 0 ? "  - Good job on varying your pitch to keep the speech engaging.\n\n" : "  - Try to vary your pitch more to add expressiveness to your speech.\n\n"
                    */
                    
                    resultString += "• Pitch Variation Analysis:\n"
                    resultString += "  - Minimum Pitch: \(String(format: "%.2f", analysis.minPitch)) Hz\n"
                    resultString += "  - Maximum Pitch: \(String(format: "%.2f", analysis.maxPitch)) Hz\n"
                  

                    if analysis.maxPitch - analysis.minPitch > 0 {
                          resultString += "  - Nice! A good range of pitch variation can add expressiveness to your speech.\n\n"
                      } else {
                          resultString += "  - Consider varying your pitch more for a dynamic speaking style.\n\n"
                      }
                    
                    // Rate of Speech Variation
                    resultString += "• Speech Rate Variation: Your rate of speech varied with a standard deviation of \(String(format: "%.2f", analysis.rateOfSpeechVariation)).\n"
                    resultString += analysis.rateOfSpeechVariation > 1 ? "  - Great! Varying your speaking rate can make your speech more engaging.\n\n" : "  - Try varying your speaking speed to maintain listener interest.\n\n"

                    // Average Pause Length
                    let formattedPauseLength = String(format: "%.2f", analysis.averagePauseLength)
                    resultString += "• Pause Usage: Your average pause length was \(formattedPauseLength) seconds.\n"
                    resultString += analysis.averagePauseLength > 1 ? "  - Great! Effective use of pauses can help emphasize points." : "  - Consider using pauses more effectively to emphasize your points."
                    
                    self.speechAnalysisResult = resultString
                    self.showAnalysis = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.speechAnalysisResult = "Please Try Recording Again. Error in analysis: \(error.localizedDescription)"
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
