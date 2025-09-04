//
//  UserInfoSetupView.swift
//  BBIP
//
//  Created by 이건우 on 8/14/24.
//

import Factory
import SwiftUI
import SwiftUIIntrospect
import LinkNavigator

struct UserInfoSetupView: View {
    let navigator: LinkNavigatorType
    @StateObject private var userInfoSetupViewModel = Container.shared.userInfoSetupViewModel()
    @State private var selectedIndex: Int = 0
    
    private func buttonText() -> String {
        guard selectedIndex == 1 else { return "다음" }
        guard !userInfoSetupViewModel.selectedInterestIndex.isEmpty else { return "다음" }
        return "\(userInfoSetupViewModel.selectedInterestIndex.count)개 선택"
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                UISActiveAreaView(viewModel: userInfoSetupViewModel)
                    .tag(0)
                
                UISInterestView(viewModel: userInfoSetupViewModel)
                    .tag(1)
                
                UISProfileView(viewModel: userInfoSetupViewModel)
                    .tag(2)
                
                UISBirthView(viewModel: userInfoSetupViewModel)
                    .tag(3)
                
                UISJobView(viewModel: userInfoSetupViewModel)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .introspect(.tabView(style: .page), on: .iOS(.v17, .v18)) { tabView in
                tabView.isScrollEnabled = false
            }
            
            VStack(spacing: 0) {
                TabViewProgressBar(value: .calculateProgress(currentValue: $selectedIndex, totalCount: userInfoSetupViewModel.contentData.count))
                    .padding(.top, 20)
                    .background(Color.gray1)
                
                TabViewHeaderView(
                    title: userInfoSetupViewModel.contentData[selectedIndex].title,
                    subTitle: userInfoSetupViewModel.contentData[selectedIndex].subTitle ?? ""
                )
                .padding(.top, 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)

                Spacer()
                   
                MainButton(
                    text: buttonText(),
                    enable: userInfoSetupViewModel.canGoNext[selectedIndex]
                ) {
                    withAnimation {
                        if selectedIndex < userInfoSetupViewModel.contentData.count - 1 {
                            selectedIndex += 1
                            BBIPLogger.log(selectedIndex, level: .debug, category: .ui)
                        } else {
                            // 유저 정보 등록
                            userInfoSetupViewModel.createUserInfo()
                        }
                    }
                }
                .padding(.bottom, 22)
            }
        }
        .toolbar(.visible, for: .navigationBar)
        .background(Color.gray1)
        .ignoresSafeArea(.keyboard)
        .handlingBackButtonStyle(currentIndex: $selectedIndex)
        .skipButton(selectedIndex: $selectedIndex, viewModel: userInfoSetupViewModel)
        .loadingOverlay(isLoading: $userInfoSetupViewModel.isLoading)
        .onChange(of: selectedIndex) { _, _ in
            hideKeyboard()
        }
        .onChange(of: userInfoSetupViewModel.showCompleteView) { _, showCompleteView in
            if showCompleteView == true {
                navigator.next(paths: [BBIPMatchPath.userInfoSetupComplete.capitalizedPath],
                               items: ["userName" : userInfoSetupViewModel.userName],
                               isAnimated: true)
            }
        }
    }
}

fileprivate extension View {
    /// 관심사 선택시에만 보여지는 건너뛰기 버튼
    func skipButton(
        selectedIndex: Binding<Int>,
        viewModel: UserInfoSetupViewModel
    ) -> some View {
        self.toolbar {
            if selectedIndex.wrappedValue == 1 {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { selectedIndex.wrappedValue += 1 }
                        viewModel.selectedInterestIndex.removeAll()
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


