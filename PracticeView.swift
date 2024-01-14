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
    
    @State private var speechAnalysisResult: String = ""
    @ObservedObject var audioRecorder = AudioRecorder()
    
    // Additional states for analysis preferences can be added here

    let backgroundGradient = LinearGradient(colors: [.pink,.cyan,.mint], startPoint: .topLeading, endPoint: .bottomTrailing)

    @State private var analyzeFillerWords = true
    @State private var analyzeRateOfSpeech = true
    @State private var analyzePitchAndMelody = true
    @State private var analyzeTonality = true
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
                     .sheet(isPresented: $showCustomization) {
                         AnalysisCustomizationView(analyzeFillerWords: $analyzeFillerWords,
                                                   analyzeRateOfSpeech: $analyzeRateOfSpeech,
                                                   analyzePitchAndMelody: $analyzePitchAndMelody,
                                                   analyzeTonality: $analyzeTonality,
                                                   analyzePause: $analyzePause)
                     }
                     .padding()

                // Placeholder for Feedback
                Text("Feedback will appear here after analysis")
                    .foregroundColor(.gray)
                    .padding()
                    .border(Color.gray, width: 1)

                // Feedback Section
                if !speechAnalysisResult.isEmpty {
                    Text(speechAnalysisResult)
                        // ... styling for feedback text
                }
                
                Spacer()
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
                    // Constructing a human-readable result
                    var resultString = "Speech Analysis:\n\n"

                    // Filler Words
                    resultString += "Filler Words: You used filler words \(analysis.fillerWordCount) times. Try to minimize these to make your speech clearer.\n\n"

                    // Average Pitch
                    resultString += "Pitch Variation: Your pitch variation was \(String(format: "%.2f", analysis.averagePitch)). "
                    resultString += (analysis.averagePitch > 0.5 ? "Good job on varying your pitch to keep the speech engaging." : "Try to vary your pitch more to add expressiveness to your speech.\n\n")

                    // Rate of Speech Variation
                    resultString += "Speech Rate Variation: Your rate of speech varied with a standard deviation of \(String(format: "%.2f", analysis.rateOfSpeechVariation)). "
                    resultString += (analysis.rateOfSpeechVariation > 0.5 ? "Great! Varying your speaking rate can make your speech more engaging." : "Try varying your speaking speed to maintain listener interest.\n\n")

                    // Average Pause Length
                    let formattedPauseLength = String(format: "%.2f", analysis.averagePauseLength)
                    resultString += "Pause Usage: Your average pause length was \(formattedPauseLength) seconds. "
                    resultString += (analysis.averagePauseLength > 0.3 ? "Effective use of pauses can help emphasize points." : "Consider using pauses more effectively to emphasize your points.\n")

                    self.speechAnalysisResult = resultString
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.speechAnalysisResult = "Error in analysis: \(error.localizedDescription)"
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
