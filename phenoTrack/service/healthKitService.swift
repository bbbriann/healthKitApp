//
//  healthKitService.swift
//  healthKitt
//
//  Created by brian on 8/19/24.
//

import HealthKit
import UserNotifications
import SwiftUI

struct CofdasfntentView: View {
    var body: some View {
        VStack {
            Button("Get sleep data") {
                fetchHealthDataAndProcess()
            }
        }
        .padding()
    }
    
    init() {
        HealthKitService.shared.configure()
    }
    
    func fetchHealthDataAndProcess() {
        let dispatchGroup = DispatchGroup()
        
        let types: [HKQuantityTypeIdentifier] = [
            .heartRate,
            .restingHeartRate,
            .walkingHeartRateAverage,
            .heartRateVariabilitySDNN,
            .distanceWalkingRunning,
            .activeEnergyBurned,
            .flightsClimbed,
            .stepCount,
            .basalEnergyBurned,
            .appleExerciseTime,
            .appleStandTime,
            .bodyMassIndex
        ]
        
        for typeIdentifier in types {
            if let quantityType = HKQuantityType.quantityType(forIdentifier: typeIdentifier) {
                dispatchGroup.enter() // 작업 시작을 알림
                HealthKitService.shared.getData(type: quantityType) {
                    // 데이터를 처리 (필요하다면 여기서 데이터를 모아 저장)
                    
                    dispatchGroup.leave() // 작업 완료를 알림
                }
            }
        }
        
        // 모든 작업이 끝났을 때 실행될 코드
        dispatchGroup.notify(queue: .main) {
            // 여기서 모든 데이터를 처리하고 후속 작업을 수행
            print("모든 데이터가 로드되었습니다.")
        }
    }
}

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


