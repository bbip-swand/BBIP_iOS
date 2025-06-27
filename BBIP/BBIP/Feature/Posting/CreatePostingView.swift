//
//  CreatePostingView.swift
//  BBIP
//
//  Created by 이건우 on 11/20/24.
//

import SwiftUI
import SwiftUIIntrospect

struct CreatePostingView: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel: CreatePostingViewModel = DIContainer.shared.createPostingViewModel()
    @State private var showWeeklyContentPicker: Bool = false
    private let studyId: String
    private let weeklyContent: [String]
    
    init(studyId: String, weeklyContent: [String]) {
        self.studyId = studyId
        self.weeklyContent = weeklyContent
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                selectWeekButton
                    .padding(.vertical, 22)
                
                titleTextField
                    .padding(.bottom, 8)
                
                postContentTextField
                
                Spacer()
            }
            .keyboardHideable()
        }
        .ignoresSafeArea(.keyboard)
        .padding(.horizontal, 16)
        .background(.gray1)
        .navigationTitle("글 작성")
        .navigationBarTitleDisplayMode(.inline)
        .backButtonStyle()
        .loadingOverlay(isLoading: $viewModel.isUploading, withBackground: false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.uploadPosting(studyId: studyId)
                } label: {
                    Text("업로드")
                        .font(.bbip(.body1_m16))
                        .foregroundStyle(viewModel.canUpload ? .mainWhite : .gray5)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.canUpload ? .primary3 : .gray2)
                        )
                }
                .disabled(!viewModel.canUpload)
            }
        }
        .sheet(isPresented: $showWeeklyContentPicker) {
            weekPicker
                .presentationDetents([.height(400)])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.uploadSuccess) { _, success in
            if success { appState.popToRoot() }
        }
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray1)
        }
    }
}

extension CreatePostingView {
    var selectWeekButton: some View {
        Button {
            showWeeklyContentPicker = true
        } label: {
            HStack(spacing: 20) {
                Text(viewModel.week == -1 ? "주차 선택" : "\(viewModel.week)주차")
                    .font(.bbip(.body2_m14))
                    .foregroundStyle(viewModel.week == -1 ? .gray5 : .mainBlack)
                Image(systemName: "chevron.down")
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .foregroundStyle(.gray5)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.mainWhite)
                    .bbipShadow1()
            )
        }
    }
    
    var titleTextField: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.mainWhite)
                .bbipShadow1()
                .frame(height: 41)
                .frame(maxWidth: .infinity)
            
            TextField(
                "",
                text: $viewModel.title,
                prompt: Text("제목 입력(20자 이내)").foregroundColor(.gray5)
            )
            .padding(.horizontal, 14)
            .font(.bbip(.body2_m14))
            .foregroundColor(.mainBlack)
            .onChange(of: viewModel.title) { oldValue, newValue in
                if newValue.count > 20 {
                    DispatchQueue.main.async {
                        viewModel.title = String(newValue.prefix(20))
                    }
                }
            }
        }
    }
    
    var postContentTextField: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.mainWhite)
                .bbipShadow1()
                .frame(height: 250)
                .frame(maxWidth: .infinity)
            
            ZStack(alignment: .topLeading) {
                if viewModel.content.isEmpty {
                    Text("본문(300자 이내)")
                        .foregroundColor(.gray5)
                        .font(.bbip(.body2_m14))
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                }
                
                TextEditor(text: $viewModel.content)
                    .frame(height: 250)
                    .font(.bbip(.body2_m14))
                    .foregroundColor(.mainBlack)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .onChange(of: viewModel.content) { oldValue, newValue in
                        if newValue.count > 300 {
                            DispatchQueue.main.async {
                                viewModel.content = String(newValue.prefix(300))
                            }
                        }
                    }
                    .introspect(.textEditor, on: .iOS(.v17, .v18)) {
                        $0.textContainerInset = .init(top: 14, left: 12, bottom: 14, right: 12)
                    }
            }
        }
    }
    
    var weekPicker: some View {
        ScrollView {
            VStack(spacing: 8) {
                // 공지글 토글
                HStack {
                    Toggle("공지글", isOn: $viewModel.isNotice)
                        .font(.bbip(.body2_m14))
                        .toggleStyle(SwitchToggleStyle(tint: .primary3))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.mainWhite)
                )
                .padding(.horizontal, 17)
                
                ForEach(0..<weeklyContent.count, id: \.self) { index in
                    WeeklyStudyContentCardView(week: index + 1, content: weeklyContent[index])
                        .onTapGesture {
                            viewModel.week = index + 1
                            showWeeklyContentPicker = false
                        }
                }
            }
            .padding(.vertical, 22)
        }
        .scrollIndicators(.hidden)
        .containerRelativeFrame([.horizontal, .vertical])
        .background(.gray1)
    }
}
