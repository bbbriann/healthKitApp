//
//  HealthKitTypeHelper.swift
//  healthKitt
//
//  Created by brian on 8/19/24.
//

import HealthKit
import UserNotifications
import SwiftUI

enum HealthKitTypeHelper {
    static func identifierString(for type: HKQuantityTypeIdentifier) -> String {
        switch type {
        case .heartRate:
            return "heartRate"
        case .restingHeartRate:
            return "restingHeartRate"
        case .walkingHeartRateAverage:
            return "walkingHeartRateAverage"
        case .heartRateVariabilitySDNN:
            return "heartRateVariabilitySDNN"
        case .headphoneAudioExposure:
            return "headphoneAudioExposure"
        case .environmentalAudioExposure:
            return "environmentalAudioExposure"
        case .distanceWalkingRunning:
            return "distanceWalkingRunning"
        case .activeEnergyBurned:
            return "activeEnergyBurned"
        case .flightsClimbed:
            return "flightsClimbed"
        case .stepCount:
            return "stepCount"
        case .basalEnergyBurned:
            return "basalEnergyBurned"
        case .appleExerciseTime:
            return "appleExerciseTime"
        case .appleStandTime:
            return "appleStandTime"
        case .bodyMassIndex:
            return "bodyMassIndex"
        // 필요한 경우 다른 identifier를 추가
        default:
            return "unknown"
        }
    }
}
