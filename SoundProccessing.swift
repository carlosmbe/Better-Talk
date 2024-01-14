//
//  SoundProccessing.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import AVFoundation
import Foundation
import Speech


func analyzeTranscription(_ transcription: SFTranscription) -> SpeechAnalysis {
    var analysis = SpeechAnalysis()
    
    // Filler words analysis
    let fillerWords = ["um", "uh", "like", "you know", "so", "actually", "basically", "I mean"]
    analysis.fillerWordCount = transcription.segments.filter {
        fillerWords.contains($0.substring.lowercased())
    }.count

    // Pitch and Rate of Speech analysis
    var totalPitch: Float = 0
    var speechRates: [Float] = []

    for segment in transcription.segments {
        let speechRate = Float(segment.duration / Double(segment.substring.count))
        speechRates.append(speechRate)

        if let voiceAnalytics = segment.voiceAnalytics {
            let pitchValues = voiceAnalytics.pitch.acousticFeatureValuePerFrame
            if !pitchValues.isEmpty {
                let sumPitch = pitchValues.reduce(0, { $0 + $1 })
                let averagePitchInSegment = Double(sumPitch) / Double(pitchValues.count)
                totalPitch += Float(averagePitchInSegment)
            }
        }
    }

    analysis.averagePitch = totalPitch / Float(transcription.segments.count)
    analysis.rateOfSpeechVariation = calculateVariation(speechRates)

    // Pause analysis
    var pauseLengths: [TimeInterval] = []
    var lastSegmentEndTime: TimeInterval = 0
    for segment in transcription.segments {
        let pauseLength = segment.timestamp - lastSegmentEndTime
        if pauseLength > 0.3 { // Pause threshold (e.g., 300 ms)
            pauseLengths.append(pauseLength)
        }
        lastSegmentEndTime = segment.timestamp + segment.duration
    }
    analysis.averagePauseLength = pauseLengths.isEmpty ? 0 : pauseLengths.reduce(0, +) / Double(pauseLengths.count)

    return analysis
}
func calculateVariation(_ rates: [Float]) -> Float {
    let mean = rates.reduce(0, +) / Float(rates.count)
    let sumOfSquaredMeanDiff = rates.map { pow($0 - mean, 2) }.reduce(0, +)
    return sqrt(sumOfSquaredMeanDiff / Float(rates.count))
}


struct SpeechAnalysis {
    var fillerWordCount: Int = 0
    var averagePitch: Float = 0
    var rateOfSpeechVariation: Float = 0
    var averagePauseLength: TimeInterval = 0
    // Other properties...
}

enum SpeechEvaluationError: Error {
    case notAuthorized
    case unknown
    case audioFileUnavailable // Example: Add this if you need an error for unavailable audio files
    // Add other cases as needed
}
