//
//  ArchiveView.swift
//  BBIP
//
//  Created by 이건우 on 9/30/24.
//

import SwiftUI
import Combine

struct ArchiveView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var viewModel: ArchiveViewModel = DIContainer.shared.makeArchiveViewModel()
    @State private var isDocumentPickerPresented: Bool = false
    @State private var cancellables = Set<AnyCancellable>()
    
    private let inviteCode: String
    private let studyId: String
    
    init(inviteCode: String, studyId: String) {
        self.inviteCode = inviteCode
        self.studyId = studyId
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let fileInfo = viewModel.archivedFileInfo {
                if fileInfo.isEmpty && !viewModel.isLoading {
                    Spacer()
                    Image("archive_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, safeAreaInsets.top + safeAreaInsets.bottom)
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(0..<fileInfo.count, id: \.self) { index in
                                ArchivedFileCardView(fileInfo: fileInfo[index])
                            }
                        }
                        .padding(.top, 22)
                        .padding(.horizontal, 20)
                    }
                }
            } else {
                VStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        ArchivedFileCardView(fileInfo: .placeholderMock())
                            .redacted(reason: .placeholder)
                            .disabled(true)
                    }
                }
                .padding(.top, 22)
                .padding(.horizontal, 20)
            }
            Spacer()
        }
        .animation(.easeInOut, value: viewModel.archivedFileInfo)
        .containerRelativeFrame([.horizontal])
        .background(.gray1)
        .navigationTitle("아카이브")
        .navigationBarTitleDisplayMode(.inline)
        .backButtonStyle()
        .onAppear {
            setNavigationBarAppearance(backgroundColor: .gray1)
            viewModel.getArchivedFile(studyId: inviteCode)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isDocumentPickerPresented = true
                } label: {
                    Image("plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 14)
                }
            }
        }
        .sheet(isPresented: $isDocumentPickerPresented) {
            DocumentPicker { fileData, fileName in
                if let fileData = fileData, let fileName = fileName {
                    let fileKey = UUID().uuidString
                    let studyId = studyId
                    
                    withAnimation { viewModel.isLoading = true }
                    AWSS3Manager.shared.upload(file: fileData, fileName: fileName, fileKey: fileKey, studyId: studyId)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .finished: break
                            case .failure(let error):
                                print(error.localizedDescription)
                                viewModel.isLoading = false
                            }
                        }, receiveValue: { success in
                            if success {
                                viewModel.getArchivedFile(studyId: inviteCode)
                            }
                        })
                        .store(in: &cancellables)
                }
            }
        }
        .loadingOverlay(isLoading: $viewModel.isLoading, withBackground: false)
    }
}

#Preview {
    ArchiveView(inviteCode: "", studyId: "")
}
