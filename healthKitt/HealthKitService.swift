//
//  HealthKitService.swift
//  healthKitt
//
//  Created by brian on 6/8/24.
//

import HealthKit

class HealthKitService {
    let healthStore = HKHealthStore()
    static let shared = HealthKitService()
    
    var data: [String: Any]?
    
    func configure() {
        // 해당 장치가 healthkit을 지원하는지 여부
        if HKHealthStore.isHealthDataAvailable() {
            DispatchQueue.main.async {
                self.requestAuthorization()
            }
        }
    }
    
    // 권한 요청 메소드
    private func requestAuthorization() {
        // 읽기 및 쓰기 권한 설정
        let read = Set([HKQuantityType(.restingHeartRate), HKQuantityType(.walkingHeartRateAverage),
                        HKQuantityType(.heartRateVariabilitySDNN), HKCategoryType(.sleepAnalysis),
                        HKQuantityType(.headphoneAudioExposure), HKQuantityType(.environmentalAudioExposure), HKQuantityType(.distanceWalkingRunning),
                        HKQuantityType(.activeEnergyBurned),
                        HKQuantityType(.flightsClimbed),
                        HKQuantityType(.stepCount),
                        HKQuantityType(.basalEnergyBurned),
                        HKQuantityType(.appleExerciseTime),
                        HKQuantityType(.appleStandTime),
                        HKQuantityType(.stepCount),
                        HKQuantityType(.distanceWalkingRunning),
                        HKQuantityType(.bodyMassIndex)
                       ])
        let share = Set([HKCategoryType(.sleepAnalysis), HKQuantityType(.heartRate)])
        self.healthStore.requestAuthorization(toShare: nil, read: read) { success, error in
            if error != nil {
                print(error.debugDescription)
            }else{
                if success {
//                    self.startObservingDataChanges()
                    print("권한이 허락되었습니다")
                }else{
                    print("권한이 없습니다")
                }
            }
        }
    }
    
    func startObservingDataChanges() {
        
        let sampleType =  HKQuantityType(.walkingSpeed)
        
        var query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: stepChangeHandler)
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { isSuccess, error in
            if isSuccess {
                print("Enabled Background Success")
            } else {
                print(error)
            }
        }
    }
    
    private func stepChangeHandler(query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error: Error?) {
        // Flag to check the background handler is working or not
        print("Backgound Mode activated")
        completionHandler()
     }

    
    func getData(type: HKSampleType, completionHandler: (() -> Void)? = nil) {
        // 데이터를 필터링할 조건(predicate)를 설정할 수 있음. 여기선 일주일 데이터를 받아오도록 설정
        let calendar = Calendar.current
        let endDate = Date() // 현재 시간
        let startDate = calendar.date(byAdding: .minute, value: -5, to: endDate) // 7일 전 시간
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        // 최신 데이터를 먼저 가져오도록 sort 기준 정의
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        // 쿼리 수행 완료시 실행할 콜백 정의
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 20, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
            if error != nil {
                // 에러 처리를 수행합니다.
                print("[Error] \(type) : err \(error!.localizedDescription)")
                completionHandler?()
                return
            }
            if let result = tmpResult {
                if result.isEmpty {
                    NSLog("Noooo data")
                }
                for item in result {
                    if let sample = item as? HKCategorySample {
                        // 가져온 데이터 출력
                        print("value: \(sample.value)")
                        print("Start Date: \(sample.startDate)")
                        print("End Date: \(sample.endDate)")
                        print("Metadata: \(String(describing: sample.metadata))")
                        print("UUID: \(sample.uuid)")
                        print("---------------------------------\n")
                    } else if let sample = item as? HKQuantitySample {
                        // 가져온 데이터 출력
                        print("quntity: \(sample.quantity)")
                        print("quntityType: \(sample.quantityType)")
                        print("Start Date: \(sample.startDate)")
                        print("End Date: \(sample.endDate)")
                        print("Metadata: \(String(describing: sample.metadata))")
                        print("UUID: \(sample.uuid)")
                        print("---------------------------------\n")
                    } else if let sample = item as? HKCumulativeQuantitySample {
                        // 가져온 데이터 출력
                        print("quntity: \(sample.sumQuantity)")
                        print("quntityType: \(sample.quantityType)")
                        print("Start Date: \(sample.startDate)")
                        print("End Date: \(sample.endDate)")
                        print("Metadata: \(String(describing: sample.metadata))")
                        print("UUID: \(sample.uuid)")
                        print("---------------------------------\n")
                    } else if let sample = item as? HKWorkout {
                        // 가져온 데이터 출력
                        print("quntity: \(sample.allStatistics)")
                        print("quntityType: \(sample.workoutActivities)")
                        print("Start Date: \(sample.startDate)")
                        print("End Date: \(sample.endDate)")
                        print("Metadata: \(String(describing: sample.metadata))")
                        print("UUID: \(sample.uuid)")
                        print("---------------------------------\n")
                    } else {
                        print("No Datatatataat")
                    }
                }
                completionHandler?()
            } else {
                completionHandler?()
            }
        }
        // HealthKit store에서 쿼리를 실행
        healthStore.execute(query)
//        callServer()
    }
    
    func callServer() {
        let session = URLSession.shared
        guard let url = URL(string: "https://f872-119-194-253-20.ngrok-free.app") else {
            return
        }
        let req = URLRequest(url: url)
        
        let task = session.dataTask(with: req) { data, response, error in
            if let error = error {
                    print("Error: \\(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data received")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch let error {
                    print("Error: \(error.localizedDescription)")
                }
        }
        
        task.resume()
    }
}
