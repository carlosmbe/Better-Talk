//
//  WaveFormView.swift
//  Better Talk
//
//  Created by Carlos Mbendera on 2024-01-13.
//

import AVFoundation
import Combine
import SwiftUI
import AVFoundation
import DSWaveformImage
import DSWaveformImageViews


struct VolumeBar: View {
    var level: CGFloat // Expected to be in the range 0...1
    private let totalDots = 20
    private let dotDiameter: CGFloat = 5
    private let spacing: CGFloat = 2
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<totalDots, id: \.self) { index in
                Circle()
                    .frame(width: dotDiameter, height: dotDiameter)
                    .foregroundColor(index < Int(level * CGFloat(totalDots)) ? .green : .gray)
                    .opacity(index < Int(level * CGFloat(totalDots)) ? 1 : 0.3)
            }
        }
        // Explicitly set the height of the VolumeBar
        .frame(height: CGFloat(totalDots) * (dotDiameter + spacing))
    }
}

struct VolumeBarsView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<10) { _ in
                VolumeBar(level: CGFloat(self.audioRecorder.samples.first ?? 0))
            }
        }
        // Reduce padding here if needed
        .padding([.top, .bottom], 10) // Example: Only top and bottom padding
    }
}

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    @Published var samples: [Float] = []
    
    var audioFileURL: URL?

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?

    override init() {
        super.init()
        setupAudioSession()
        setupRecorder()
    }

    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            print("Audio session setup and activated.")
        } catch {
            print("Failed to set up and activate audio session: \(error)")
        }
    }

    private func setupRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        print("Audio file path: \(audioFilename.path)")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            print("Audio recorder setup successfully.")
        } catch {
            print("Failed to set up the audio recorder: \(error)")
        }
    }

    func startRecording() {
        guard let recorder = audioRecorder, recorder.prepareToRecord() else {
            print("Audio recorder is not ready or failed to prepare.")
            return
        }
        
        if recorder.record(atTime: recorder.deviceCurrentTime + 0.01) {
            isRecording = true
            startUpdatingMeter()
            print("Recording started.")
        } else {
            print("Failed to start recording.")
        }
    }




    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        audioFileURL = audioRecorder?.url
        stopUpdatingMeter()
    }

    private func startUpdatingMeter() {
        audioRecorder?.isMeteringEnabled = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.audioRecorder?.updateMeters()
            // Get the average power level in decibels
            let averagePower = self?.audioRecorder?.averagePower(forChannel: 0) ?? 0
            // Convert to a 0-1 scale (you may need to adjust the factor based on testing)
            let linearLevel = min(max((averagePower + 160) / 160, 0), 1)
            self?.samples = [linearLevel] // We use samples to store our level
        }
    }



    private func stopUpdatingMeter() {
        timer?.invalidate()
        timer = nil
    }

    private func checkMicrophonePermission(completion: @escaping () -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion()
        case .denied:
            print("Microphone permission denied")
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        default:
            break
        }
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
