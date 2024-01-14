//
//  FundamentalHelperViews.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-14.
//

import AVFoundation
import SwiftUI

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

struct VolumePitchView: View {
    @Binding var speechSynthesizer: AVSpeechSynthesizer

    var body: some View {
        VStack {
            Text("Experiment with different volumes and pitches. How does changing these elements impact the way your message is received?")
            
            HStack {
                         Button("Play Constant Volume & Pitch") {
                             playSpeech(volume: 1.0, pitch: 1.0, varying: false)
                         }
                         .buttonStyle(PlainButtonStyle())
                         .padding()
                         .background(Color.orange)
                         .foregroundColor(Color.white)
                         .cornerRadius(10)

                         Button("Play Varying Volume & Pitch") {
                             playSpeech(volume: 1.0, pitch: 1.0, varying: true)
                         }
                         .buttonStyle(PlainButtonStyle())
                         .padding()
                         .background(Color.cyan)
                         .foregroundColor(Color.white)
                         .cornerRadius(10)
                     }
            
        }
    }

    private func playSpeech(volume: Float, pitch: Float, varying: Bool = false) {
        if varying {
            let phrases = ["This sentence", "is spoken", "with adjusted", "volume and pitch"]
            let volumes: [Float] = [1.0, 0.9, 1.0, 1.05]  // More gradual changes
            let pitches: [Float] = [1.0, 1.2, 1.0, 1.0]  // More gradual changes

            for (index, phrase) in phrases.enumerated() {
                let utterance = AVSpeechUtterance(string: phrase)
                utterance.volume = volumes[index]
                utterance.pitchMultiplier = pitches[index]
                speechSynthesizer.speak(utterance)
            }
        } else {
            let utterance = AVSpeechUtterance(string: "This sentence is spoken with a constant volume and pitch.")
            utterance.volume = volume
            utterance.pitchMultiplier = pitch
            speechSynthesizer.speak(utterance)
        }
    }



}

struct RateOfSpeechView: View {
    @Binding var speechSynthesizer: AVSpeechSynthesizer

    var body: some View {
        VStack {
            Text("Notice how the rate of your speech affects comprehension and audience engagement.")
            
            HStack {
                  Button("Play Constant Rate Speech") {
                      playSpeech(rate: AVSpeechUtteranceDefaultSpeechRate, varyingRate: false)
                  }
                  .buttonStyle(PlainButtonStyle())
                  .padding()
                  .background(Color.orange)
                  .foregroundColor(Color.white)
                  .cornerRadius(10)

                  Button("Play Varying Rate Speech") {
                      playSpeech(rate: AVSpeechUtteranceDefaultSpeechRate, varyingRate: true)
                  }
                  .buttonStyle(PlainButtonStyle())
                  .padding()
                  .background(Color.cyan)
                  .foregroundColor(Color.white)
                  .cornerRadius(10)
              }
            
        }
    }

    private func playSpeech(rate: Float, varyingRate: Bool = false) {
        if varyingRate {
            let phrases = ["This sentence", "starts slowly", "then speeds up", "and finally slows down again"]
            // Using rates that change more gradually
            let rates: [Float] = [0.45, 0.52, 0.526, 0.48]

            for (index, phrase) in phrases.enumerated() {
                let utterance = AVSpeechUtterance(string: phrase)
                utterance.rate = rates[index]
                speechSynthesizer.speak(utterance)
            }
        } else {
            let utterance = AVSpeechUtterance(string: "This sentence is spoken at a constant rate.")
            utterance.rate = rate
            speechSynthesizer.speak(utterance)
        }
    }


    
}

struct FillerWordsView: View {
    @Binding var speechSynthesizer: AVSpeechSynthesizer

    var body: some View {
        VStack {
            Text("Become aware of filler words in your speech. Try to minimize them for a clearer and more concise message.")
            HStack {
                Button("Play with Filler Words") {
                    let textWithFillers = "Well, um, this sentence, you know, has, like, a lot of filler words."
                    playSpeech(text: textWithFillers)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.orange)
                .foregroundColor(Color.white)
                .cornerRadius(10)

                Button("Play without Filler Words") {
                    let textWithoutFillers = "This sentence has no filler words."
                    playSpeech(text: textWithoutFillers)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.cyan)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }
        }
    }

    private func playSpeech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(utterance)
    }
}

struct PausesView: View {
    @Binding var speechSynthesizer: AVSpeechSynthesizer

    var body: some View {
        VStack {
            Text("Strategic pauses can add impact to your speech. Practice pausing after key points for effect.")
            
            HStack {
                Button("Play Speech without Pauses") {
                    let textWithoutPauses = "This sentence has no strategic pauses and goes on and on and on."
                    playSpeech(text: textWithoutPauses)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.orange)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
                Button("Play Speech with Pauses") {
                    let textWithPauses = "This sentence..... has strategic... pauses."
                    playSpeech(text: textWithPauses)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(Color.cyan)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            }
            
        }
    }

    private func playSpeech(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(utterance)
        }
    }
