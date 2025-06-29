//
//  StudyInfoSetupView.swift
//  BBIP
//
//  Created by 이건우 on 8/29/24.
//

import SwiftUI
import SwiftUIIntrospect
import LinkNavigator
import Factory

struct StudyInfoSetupView: View {
    let navigator: LinkNavigatorType
    
    @StateObject private var createStudyViewModel = Container.shared.createStudyViewModel()
    @State private var selectedIndex: Int = .zero
    
    var body: some View {
        ZStack() {
            TabView(selection: $selectedIndex) {
                SISCategoryView(viewModel: createStudyViewModel)
                    .tag(0)
                
                SISPeriodView(viewModel: createStudyViewModel)
                    .tag(1)
                
                SISProfileView(viewModel: createStudyViewModel)
                    .tag(2)
                
                SISDescriptionView(viewModel: createStudyViewModel)
                    .tag(3)
                
                SISWeeklyContentView(viewModel: createStudyViewModel)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .introspect(.tabView(style: .page), on: .iOS(.v17, .v18)) {
                $0.isScrollEnabled = false
            }
            
            VStack(spacing: 0) {
                TabViewProgressBar(value: .calculateProgress(currentValue: $selectedIndex, totalCount: createStudyViewModel.contentData.count))
                    .background(.gray7)
                    .padding(.top, 20)
                    .background(Color.gray9)
                
                TabViewHeaderView(
                    title: createStudyViewModel.contentData[selectedIndex].title,
                    subTitle: createStudyViewModel.contentData[selectedIndex].subTitle,
                    reversal: true
                )
                .padding(.top, 48)
                .padding(.bottom, 16) // scrollable view에서 header와 contentView의 간격
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray9)
                .padding(.horizontal, 20)

                Spacer()
                   
                MainButton(
                    text: createStudyViewModel.goEditPeriod ? "돌아가기" : "다음",
                    enable: createStudyViewModel.canGoNext[selectedIndex],
                    disabledColor: .gray8
                ) {
                    handleNextButtonTap()
                }
                .padding(.top, 16)
                .padding(.bottom, 22)
                .background(.gray9)
            }
        }
        .onAppear {
            setNavigationBarAppearance(forDarkView: true)
        }
        .onChange(of: createStudyViewModel.goEditPeriod) { _, newVal in
            if newVal {
                withAnimation { selectedIndex = 1 }
            }
        }
        .onChange(of: createStudyViewModel.showCompleteView) { _, showCompleteView in
            if showCompleteView == true {
                navigator.next(paths: [BBIPMatchPath.studyInfoSetupComplete.capitalizedPath],
                               items: ["studyId" : createStudyViewModel.createdStudyId,
                                       "studyInviteCode" : createStudyViewModel.studyInviteCode],
                               isAnimated: true)
            }
        }
        .colorScheme(.dark)
        .navigationTitle("생성하기")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray9)
        .ignoresSafeArea(.keyboard)
        .handlingBackButtonStyle(currentIndex: $selectedIndex, isReversal: true)
        .skipButtonForSISDescriptionView(selectedIndex: $selectedIndex, viewModel: createStudyViewModel)
        .loadingOverlay(isLoading: $createStudyViewModel.isLoading, withBackground: true)
        .navigationDestination(isPresented: $createStudyViewModel.showCompleteView) {
            // LN TODO: 삭제 예정
            StudyInfoSetupCompleteView(
                navigator: navigator,
                studyId: createStudyViewModel.createdStudyId,
                studyInviteCode: createStudyViewModel.studyInviteCode
            )
        }
    }

    // 다음 버튼 동작 처리
    private func handleNextButtonTap() {
        withAnimation {
            if createStudyViewModel.goEditPeriod {
                selectedIndex = 4
                createStudyViewModel.goEditPeriod = false
            } else if selectedIndex < createStudyViewModel.contentData.count - 1 {
                selectedIndex += 1
            } else {
                createStudyViewModel.createStudy()
            }
        }
    }
}


fileprivate extension View {
    /// 스터디 한 줄 소개 작성 뷰에서만 보여지는 건너뛰기 버튼
    func skipButtonForSISDescriptionView(
        selectedIndex: Binding<Int>,
        viewModel: CreateStudyViewModel
    ) -> some View {
        self.toolbar {
            if selectedIndex.wrappedValue == 3 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { selectedIndex.wrappedValue += 1 }
                        viewModel.studyDescription = .init()
                        hideKeyboard()
                    } label: {
                        Text("건너뛰기")
                            .font(.bbip(.caption1_m16))
                            .frame(height: 24)
                            .foregroundStyle(.gray5)
                    }
                }
            }
        }
    }
}
