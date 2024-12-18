//
//  HomeView.swift
//  healthKitt
//
//  Created by brian on 8/26/24.
//

import Combine
import SwiftUI

struct HomeView: View {
    @Binding var path: [HomeViewStack]
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var historyViewModel = HistoryViewModel()
    @State private var showBottomSheet: Bool = false
    @State private var showReadyToStartSheet: Bool = false
    @State private var showSurveyGuideSheet: Bool = false
    @State private var bottomSheetHeight: CGFloat = 0
    
    @State private var showRandomSurveyView: Bool = false
    
    @State private var showPreviousHistoryView: Bool = false
    
    @State private var isTaskExecuted = false
    
    init(path: Binding<[HomeViewStack]>) {
        self._path = path
        HealthKitService.shared.configure()
    }
    
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Spinner()
            } else {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 0) {
                                Text("Pheno")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color(hex: "#020C1C"))
                                Text("Track")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(Color.mainColor)
                            }
                            HStack(spacing: 0) {
                                Text("좋은 하루입니다, ")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "#020C1C"))
                                Text("\(UserDefaults.standard.userInfo?.first_name ?? "")님")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "##0056E6"))
                                Spacer()
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                // Body/16px/Medium
                                Text(viewModel.study?.description ?? "")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "#020C1C"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack {
                                    HStack(alignment: .center, spacing: 10) {
                                        Text(viewModel.studyPeriod)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(Color(hex: "#020C1C"))
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.white)
                                    .cornerRadius(15)
                                    Spacer()
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center) {
                                    HStack(alignment: .center, spacing: 12) {
                                        Image("IcAlarm")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                        Text("알림")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(Color(hex: "#020C1C"))
                                    }
                                    Spacer()
                                    if viewModel.showInfoButton {
                                        Button {
                                            switch viewModel.homeState {
                                            case .notApproved:
                                                showBottomSheet.toggle()
                                            case .readyToStart:
                                                showReadyToStartSheet.toggle()
                                            case .noSurvey:
                                                do {}
                                            case .survey:
                                                showSurveyGuideSheet.toggle()
                                            case .surveyFinish:
                                                do {}
                                            }
                                        } label: {
                                            HStack(alignment: .center, spacing: 4) {
                                                Image("IcInfo")
                                                    .resizable()
                                                    .frame(width: 16, height: 16)
                                                // Body/12px/Medium
                                                Text(viewModel.infoTitle)
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .frame(height: 24, alignment: .leading)
                                            .background(Color(hex: "#1068FD"))
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56, alignment: .center)
                                .background(Color(red: 0.88, green: 0.94, blue: 1))
                                
                                switch viewModel.homeState {
                                case .notApproved:
                                    HStack(alignment: .center, spacing: 0) {
                                        Image("IcHomeNoData")
                                            .resizable()
                                            .frame(width: 140, height: 140)
                                    }
                                    .padding(.top, 16)
                                    .padding(.bottom, 24)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    Text("어플리케이션을 이용하시기 위해서는 연구자\n승인이 필요합니다.")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "#020C1C"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                case .readyToStart:
                                    Image("IcHomeApproval")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    VStack(alignment: .leading, spacing: 32) {
                                        VStack(alignment: .leading, spacing: 16) {
                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack(alignment: .center) {
                                                    Text("총 연구 기간 (6주):")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                    
                                                    Text("2024.06.13 ~ 2024.07.25")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                }
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                
                                                HStack(alignment: .center) {
                                                    Text("이용 기간 (3주):")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                    
                                                    Text("2024.06.13 ~ 2024.07.04")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                }
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            
                                            // Body/14px/Medium
                                            Text("이용 기간 동안 수집된 휴대폰 데이터와 설문을 바탕으로 섭식장애 증상을 예측 하는 연구를 진행합니다")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(hex: "#020C1C"))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .padding(.horizontal, 20)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        Button {
                                            showReadyToStartSheet.toggle()
                                        } label: {
                                            CommonSelectButton(title: "연구를 시작하세요",
                                                               titleColor: .white,
                                                               bgColor: Color(hex: "#1068FD"),
                                                               cornerRadius: 16)
                                            .padding(.horizontal, 20)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                case .noSurvey:
                                    HStack(alignment: .center, spacing: 0) {
                                        Image("IcHomeNoSurvey")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .padding(.top, 15)
                                    .padding(.bottom, 15)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    
                                    Text("작성 대기중인 설문이 없습니다.")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color(hex: "#020C1C"))
                                        .frame(maxWidth: .infinity, alignment: .center)
                                case .survey:
                                    HStack(alignment: .center, spacing: 0) {
                                        Image("IcHomeSurvey")
                                            .frame(maxWidth: .infinity, alignment: .center)
                                    }
                                    .padding(.top, 15)
                                    .padding(.bottom, 15)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    VStack(alignment: .center, spacing: 32) {
                                        VStack(alignment: .center, spacing: 16) {
                                            Text("설문 작성 대기중")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(Color(hex: "#020C1C"))
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            CountDownView(endDate: DateHelper.convertToDate(viewModel.latestNoti?.endAt ?? "") ?? Date())
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        Button {
                                            path.append(.survey)
                                        } label: {
                                            CommonSelectButton(title: "작성하기",
                                                               titleColor: .white,
                                                               bgColor: Color(hex: "#1068FD"),
                                                               cornerRadius: 16)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 0)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                case .surveyFinish:
                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("휴대폰 데이터를 이용한 섭식장애 증상\n예측 연구")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color(hex: "#020C1C"))
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        VStack(alignment: .leading, spacing: 16) {
                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack(alignment: .center) {
                                                    Text("총 연구 기간 (6주):")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                    
                                                    Text("2024.06.13 ~ 2024.07.25")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                }
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                                
                                                HStack(alignment: .center) {
                                                    Text("이용 기간 (3주):")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                    
                                                    Text("2024.06.13 ~ 2024.07.04")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(Color(hex: "#020C1C"))
                                                }
                                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            
                                            // Body/14px/Medium
                                            Text("이용 기간 동안 수집된 휴대폰 데이터와 설문을 바탕으로 섭식장애 증상을 예측 하는 연구를 진행합니다")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(hex: "#020C1C"))
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                        Button {
                                            path.append(.prevHistory)
                                        } label: {
                                            CommonSelectButton(title: "지난 기록 보기",
                                                               titleColor: .white,
                                                               bgColor: Color(hex: "#1068FD"),
                                                               cornerRadius: 16)
        //                                    .padding(.horizontal, 20)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.top, 20)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                            }
                            .padding(.bottom, viewModel.bottomPadding)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(16)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                }
                .refreshable {
                    viewModel.fetchHomeData()
                }
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98))
        .sheet(isPresented: $showBottomSheet, content: {
            // 연구자 승인 대기 시트
            PendingApprovalView(height: $bottomSheetHeight)
                .background(Color.white)
                .presentationDetents([.height(370)])
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $showReadyToStartSheet, content: {
            // 연구 안내 시트
            ResearchInfoSheetView(height: $bottomSheetHeight, state: $viewModel.homeState)
                .background(Color.white)
                .presentationDetents([.height(472)])
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $showSurveyGuideSheet, content: {
            // 작성 방법 시트
            ReportGuideView(height: $bottomSheetHeight)
                .background(Color.white)
                .presentationDetents([.height(432)])
                .presentationDragIndicator(.visible)
        })
        .task {
            if !isTaskExecuted {
                viewModel.fetchHomeData()
                viewModel.setFCMToken()
                isTaskExecuted = true
            }
        }
        .navigationDestination(for: HomeViewStack.self) { viewType in
            switch viewType {
            case .survey:
                RandomSurveyView(path: $path)
            case .surveyComplete:
                RandomSurveyCompleteView(path: $path)
            case .home:
                EmptyView()
            case .prevHistory:
                PreviousHistoryView(path: $path)
                    .environmentObject(historyViewModel)
            case .prevDiaryResult:
                DiaryResultView(diaryPath: .constant([]),
                                historyPath: .constant([]),
                                homePath: $path,
                                diet: $historyViewModel.selectedDiet)
            case .prevRandomSurveyResult:
                RandomSurveyResultView(historyPath: .constant([]), homePath: $path,
                                       randomSurvey: $historyViewModel.selectedRandomSurvey)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .homeViewRefresh)) { notification in
            viewModel.fetchHomeData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .showRandomSurveyFromPush)) { notification in
            path.removeLast(path.count)
            path.append(.survey)
        }
    }
}


struct PendingApprovalView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var height: CGFloat
    
    var body: some View {
        VStack {
            Text("승인 대기중")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(height: 20)
            Text("어플리케이션을 이용하시기 위해서는 연구자 승인이 필요합니다.")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Color.clear
                .frame(height: 12)
            
            Text("동의서 작성 후 연구자가 승인하면, 어플리케이션 사용이 가능합니다. 이용방법은 연구자에게 문의하시기 바랍니다.")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Color.clear
                .frame(height: 48)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                CommonSelectButton(title: "확인",
                                   titleColor: .white,
                                   bgColor: Color(hex: "#1068FD"))
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
        .readSize { calculatedHeight in
            height = calculatedHeight.height
        }
    }
}


struct ResearchInfoSheetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var height: CGFloat
    @Binding var state: HomeState
    @State private var pageIndex = 0
    private var textList: [String] = [
        "본 연구는 강남세브란스 병원에서 진행되며, 이용 기간 동안 수집된 휴대폰 데이터와 설문 결과를 바탕으로 딥러닝 및 머신러닝 기법을 활용하여 섭식장애 증상을 예측하는 것을 목표로 합니다 이용 기간 종료일에 어플리케이션이 종료되오니, 연구진의 지시사항을 잘 따라 주시길 부탁드립니다.",
        "본 연구에서는 두 가지 설문이 진행됩니다.\n[랜덤 설문] 매일 5번 작성하는 설문\n[식사 일기] 식사 때마다 작성하는 설문\n\n첫번째 설문은 알림이 오면 1시간 안에 작성 하시고, 두번째 설문은 식사를 마친 후 혹은 간식을 먹은 후 식사일기 탭으로 들어가셔서 작성해 주세요.",
        "2주 연속으로 일주일에 3일 미만으로 사용하시는 경우 중도 탈락 될 수 있습니다. 연구기간 동안 성실히 작성 부탁드립니다. 연구 기간에 맞추어 연락을 드리도록 하겠습니다"
    ]
    
    init(height: Binding<CGFloat>, state: Binding<HomeState>) {
        self._height = height
        self._state = state
    }
    
    var body: some View {
        VStack {
            Color.clear
                .frame(height: 32)
            Text("연구 안내")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(height: 20)
            VStack(spacing: 12) {
                Text("휴대폰 데이터로 섭식장애 증상 예측하는 연구")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#020C1C"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack() {
                    HStack(alignment: .center, spacing: 10) {
                        Text("2024.06.13 ~ 2024.07.04")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "#006EEF"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#006EEF").opacity(0.2))
                    .cornerRadius(999)
                    
                    Spacer()
                }
            }
            
            TabView(selection: $pageIndex) {
                ForEach(0..<3) { index in
                    VStack {
                        Text(textList[index])
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#020C1C"))
                    }
                    .frame(height: 266)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic)) // 캐러셀 스타일 적용
            .indexViewStyle(.page)
            .onAppear {
                setupAppearance()
            }
            Color.clear
                .frame(height: 32)
            
            Button {
                if pageIndex == 2 {
                    UserDefaults.standard.surveyAgreed = true
                    state = .noSurvey
                    presentationMode.wrappedValue.dismiss()
                } else {
                    pageIndex += 1
                }
            } label: {
                CommonSelectButton(title: pageIndex == 2 ? "확인" : "다음",
                                   titleColor: .white,
                                   bgColor: Color(hex: "#1068FD"))
            }
        }
        .padding(.horizontal, 24)
        .readSize { calculatedHeight in
            print("calculatedHeight.height \(calculatedHeight.height)")
            height = calculatedHeight.height
        }
    }
    
    private func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(hex: "#1068FD"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(hex: "#E3E5E5"))
    }
}


struct ReportGuideView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var height: CGFloat
    
    var body: some View {
        VStack {
            Text("작성 방법")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity)
            Color.clear
                .frame(height: 20)
            Text("휴대폰 데이터로 섭식장애 증상 예측하는 연구")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Color.clear
                .frame(height: 12)
            
            Text("[랜덤 설문] 하루 5번 알림이 오면\n1시간 안에 메세지 박스의 설문을 작성해 주세요.\n시간 안에 작성하지 못하는 경우엔 다음 설문 알림이 오면 진행해 주세요\n[식사일기]식사나 간식을 드신 후 바로 작성해주세요\n* 식사일기는 바로 작성하지 못하셔도, 나중에 기억 나시는 대로 기록하시면 됩니다.")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#020C1C"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Color.clear
                .frame(height: 48)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                CommonSelectButton(title: "확인",
                                   titleColor: .white,
                                   bgColor: Color(hex: "#1068FD"))
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
        .readSize { calculatedHeight in
            height = calculatedHeight.height
        }
    }
}

struct CountDownView: View {
    @State private var timeRemaining: String = "00:00:00"
    @State private var timerSubscription: AnyCancellable?
    
    let endDate: Date
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // Body/14px/Medium
            Text(timeRemaining)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#DA072D"))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color(hex: "#DA072D").opacity(0.2))
        .cornerRadius(14)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
    }
    
    private func startTimer() {
        // 타이머 설정, 1초마다 실행
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                updateCountdown()
            }
    }
    
    private func updateCountdown() {
        let now = Date()
        let remainingTime = endDate.timeIntervalSince(now)
        
        if remainingTime <= 0 {
            // 남은 시간이 0이거나 지났으면 타이머 중지 및 00:00:00으로 설정
            timeRemaining = "00:00:00"
            timerSubscription?.cancel()
        } else {
            // 남은 시간을 시:분:초 형태로 계산
            let hours = Int(remainingTime) / 3600
            let minutes = Int(remainingTime) / 60 % 60
            let seconds = Int(remainingTime) % 60
            timeRemaining = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
