//
//  AppStateViewModel.swift
//  healthKitt
//
//  Created by brian on 9/13/24.
//

import SwiftUI

import Combine
import HealthKit

class AppStateViewModel: ObservableObject {
    @Published var isLoading: Bool = true // API 호출 상태를 추적하는 변수
    private var cancellables = Set<AnyCancellable>()
    
    private let interactor: AuthInteractor
    
    init(interactor: AuthInteractor = AuthInteractor()) {
        self.interactor = interactor
        fetchInitialData()
    }
    
    func fetchInitialData() {
        // 초기 데이터(API 호출)를 가져오는 메서드
        if let token = UserDefaults.standard.accessToken {
            interactor.fetchUserInfo()
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching initial data: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                    self?.isLoading = false // API 호출이 끝나면 로딩 상태 해제
                }, receiveValue: { userInfo in
                    // API 호출 결과 처리
                    UserDefaults.standard.userInfo = userInfo
                    print("Fetched user info: \(userInfo)")
                })
                .store(in: &cancellables)
        } else {
            self.isLoading = false // API 호출이 끝나면 로딩 상태 해제
        }
    }
    
    func fetchHealthDataAndProcess() {
        let dispatchGroup = DispatchGroup()
        
        let types: [HKObjectType] = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!,
            HKQuantityType.quantityType(forIdentifier: .walkingHeartRateAverage)!,
            HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKQuantityType.quantityType(forIdentifier: .appleStandTime)!,
            HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKQuantityType.quantityType(forIdentifier: .headphoneAudioExposure)!,
            HKQuantityType.quantityType(forIdentifier: .environmentalAudioExposure)!,
            HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)!
        ]
        for type in types {
            if let quantityType = type as? HKQuantityType {
                dispatchGroup.enter() // 작업 시작을 알림
                HealthKitService.shared.getData(type: quantityType) { samples, error in
                    if let samples = samples,
                       let processedData = self.processHealthSamples(samples, type: quantityType) {
                        self.interactor.sendSensorData(req: processedData)
                            .sink(receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                                switch completion {
                                case .failure(let error):
                                    print("[TEST] error \(error)")
                                case .finished:
                                    break
                                }
                            }, receiveValue: { [weak self] (res) in
                                print("[TEST] res \(res)")
                            })
                            .store(in: &self.cancellables)
                        // JSON으로 변환 (예시)
                        if let jsonData = try? JSONEncoder().encode(processedData),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            
                            print("정제된 데이터: \(jsonString)")
                        }
                    }
                    
                    dispatchGroup.leave() // 작업 완료를 알림
                }
            } else if let categoryType = type as? HKCategoryType {
                // HKCategoryType에 대한 처리
                dispatchGroup.enter() // 작업 시작을 알림
                HealthKitService.shared.getData(type: categoryType) { samples, error in
                    if let samples = samples,
                       let processedData = self.processHealthSamples(samples, type: categoryType) {
                        self.interactor.sendSensorData(req: processedData)
                            .sink(receiveCompletion: { [weak self] (completion: Subscribers.Completion<Error>) in
                                switch completion {
                                case .failure(let error):
                                    print("[TEST] error \(error)")
                                case .finished:
                                    break
                                }
                            }, receiveValue: { [weak self] (res) in
                                print("[TEST] res \(res)")
                            })
                            .store(in: &self.cancellables)
                        // JSON으로 변환 (예시)
                        if let jsonData = try? JSONEncoder().encode(processedData),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            
                            print("정제된 데이터: \(jsonString)")
                        }
                    }
                    
                    dispatchGroup.leave() // 작업 완료를 알림
                }
            }
        }
        
        // 모든 작업이 끝났을 때 실행될 코드
        dispatchGroup.notify(queue: .main) {
            // 여기서 모든 데이터를 처리하고 후속 작업을 수행
            // 새로운 endDate 저장 (현재 요청한 시간)
            UserDefaults.standard.lastEndDate = Date()
            print("모든 데이터가 로드되었습니다.")
        }
    }
    
    // 데이터를 주어진 JSON 구조에 맞게 정제하는 함수
    private func processHealthSamples(_ samples: [HKSample], type: HKObjectType) -> HealthData? {
        guard let firstSample = samples.first else { return nil }
        
        let sensorType = HealthKitTypeHelper.identifierString(for: type)
        let startAt = iso8601String(from: firstSample.startDate)
        let endAt = iso8601String(from: firstSample.endDate)
        
        let values: [HealthDataValue] = samples.compactMap { sample in
            if let quantitySample = sample as? HKQuantitySample {
                let valueString = quantitySample.quantity.description
                return HealthDataValue(
                    start_at: iso8601String(from: sample.startDate),
                    end_at: iso8601String(from: sample.endDate),
                    value: valueString
                )
            }
            return nil
        }
        
        let healthData = HealthData(
            sensor_type: sensorType,
            start_at: startAt,
            end_at: endAt,
            values: values,
            memo: "Health data from HealthKit" // memo는 임의로 설정
        )
        
        return healthData
    }
    
    private func iso8601String(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 표준 시간대로 설정
        return formatter.string(from: date)
    }
}
