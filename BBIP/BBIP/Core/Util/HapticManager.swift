//
//  HapticManager.swift
//  BBIP
//
//  Created by 이건우 on 8/28/24.
//

import SwiftUI
import Foundation
import CoreHaptics

public class HapticManager {
    public static let shared = HapticManager()
    
    private var hapticEngine: CHHapticEngine?
    
    init() {
        self.hapticEngine = createEngine()
    }
    
    /// 버튼 누르는 느낌의 햅틱
    public func homeButtonTouchDown() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 버튼 떼는 느낌의 햅틱
    public func homeButtonTouchUp() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 또르르...
    public func unexpectedDelight() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
    
    /// 통통
    public func tongtong() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// 톡
    public func tok() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 붕
    public func boong() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// 드르륵
    public func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    /// 패턴 재생(패턴은 추후 협의 후 개발해서 추가)
    public func playHapticPattern() {
        do {
            try hapticEngine?.start()
            
            let pattern = try createHapticPattern()
            let player = try hapticEngine?.makePlayer(with: pattern)
            
            try player?.start(atTime: 0)
        } catch let error {
            print("Error playing haptic pattern: \(error)")
        }
    }
}

private extension HapticManager {
    func createEngine() -> CHHapticEngine? {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return nil
        }
        
        do {
            return try CHHapticEngine()
        } catch let error {
            print("Error creating haptic engine: \(error)")
            return nil
        }
    }
    
    func createHapticPattern() throws -> CHHapticPattern {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            
        let events = [CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: 0)]

        return try CHHapticPattern(events: events, parameters: [])
    }
}
