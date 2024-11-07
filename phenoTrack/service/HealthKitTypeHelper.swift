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
    static func identifierString(for type: HKObjectType) -> String {
        if let quantityType = type as? HKQuantityType {
            switch quantityType.identifier {
            case HKQuantityTypeIdentifier.heartRate.rawValue:
                return "heartRate"
            case HKQuantityTypeIdentifier.restingHeartRate.rawValue:
                return "restingHeartRate"
            case HKQuantityTypeIdentifier.walkingHeartRateAverage.rawValue:
                return "walkingHeartRateAverage"
            case HKQuantityTypeIdentifier.heartRateVariabilitySDNN.rawValue:
                return "heartRateVariabilitySDNN"
            case HKQuantityTypeIdentifier.headphoneAudioExposure.rawValue:
                return "headphoneAudioExposure"
            case HKQuantityTypeIdentifier.environmentalAudioExposure.rawValue:
                return "environmentalAudioExposure"
            case HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue:
                return "distanceWalkingRunning"
            case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
                return "activeEnergyBurned"
            case HKQuantityTypeIdentifier.flightsClimbed.rawValue:
                return "flightsClimbed"
            case HKQuantityTypeIdentifier.stepCount.rawValue:
                return "stepCount"
            case HKQuantityTypeIdentifier.basalEnergyBurned.rawValue:
                return "basalEnergyBurned"
            case HKQuantityTypeIdentifier.appleExerciseTime.rawValue:
                return "appleExerciseTime"
            case HKQuantityTypeIdentifier.appleStandTime.rawValue:
                return "appleStandTime"
            case HKQuantityTypeIdentifier.bodyMassIndex.rawValue:
                return "bodyMassIndex"
            default:
                return "unknownQuantityType"
            }
        } else if let categoryType = type as? HKCategoryType {
            switch categoryType.identifier {
            case HKCategoryTypeIdentifier.sleepAnalysis.rawValue:
                return "sleepAnalysis"
            default:
                return "unknownCategoryType"
            }
        } else {
            return "unknownType"
        }
    }
}
