//
//  OnboardingView.swift
//  BBIP
//
//  Created by 이건우 on 8/10/24.
//

import SwiftUI
import Factory
import LinkNavigator
import SwiftUIIntrospect

struct OnboardingView: View {
    let navigator: LinkNavigatorType
    
    @StateObject private var onboardingViewModel = Container.shared.onboardingViewModel()
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                OnboardingContentView(onboardingViewModel: onboardingViewModel)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
            
            TabViewPageIndicator(
                contentCount: onboardingViewModel.onboardingContents.count,
                selectedIndex: $selectedIndex
            )
            
            Image(onboardingViewModel.onboardingContents[selectedIndex].textImageName)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 110)
            
            Rectangle()
                .frame(height: 136)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray1, Color.clear]),
                        startPoint: UnitPoint(x: 0.5, y: 0.05),
                        endPoint: UnitPoint(x: 0.5, y: 0)
                    )
                )
                .frame(maxHeight: .infinity, alignment: .bottom)
            
            MainButton(text: "다음") {
                if selectedIndex < onboardingViewModel.onboardingContents.count - 1 {
                    withAnimation { selectedIndex += 1 }
                } else {
                    navigator.next(paths: [BBIPMatchPath.login.capitalizedPath], items: [:], isAnimated: true)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 39)
        }
        .navigationBarBackButtonHidden()
        .background(Color.gray1)
    }
}

private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, content in
            Image(onboardingViewModel.onboardingContents[index].imageName)
                .resizable()
                .scaledToFill()
                .padding(.horizontal, 58)
                .padding(.top, 200)
                .tag(index)
        }
    }
}

private struct TabViewPageIndicator: View {
    @State private var contentCount: Int
    @Binding var selectedIndex: Int
    
    fileprivate init(
        contentCount: Int,
        selectedIndex: Binding<Int>
    ) {
        self.contentCount = contentCount
        self._selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<contentCount, id: \.self) { index in
                Circle()
                    .fill(selectedIndex == index ? Color.gray8 : Color.gray3)
                    .frame(width: 8, height: 8)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 48)
    }
}
