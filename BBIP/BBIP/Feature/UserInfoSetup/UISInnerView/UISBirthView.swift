import Foundation
import SwiftUI

struct UISBirthView: View {
    
    @ObservedObject var viewModel: UserInfoSetupViewModel
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Spacer(minLength: 40)
                ForEach(0..<4, id: \.self) { index in
                    createTextField(for: index)
                }
                Spacer(minLength: 40)
            }
            .padding(.top, 222)
            
            createWarningLabel()
            
            Spacer()
        }
        .onAppear {
            focusedField = isYearComplete() ? 3 : 0
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private func createTextField(for index: Int) -> some View {
        TextField("", text: $viewModel.yearDigits[index])
            .font(.bbip(family: .SemiBold, size: 48))
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .focused($focusedField, equals: index)
            .onChange(of: viewModel.yearDigits[index]) { _, newValue in
                handleTextFieldChange(index: index, newValue: newValue)
            }
            .underlineView(isActive: !viewModel.yearDigits[index].isEmpty || focusedField == index, isError: !viewModel.isYearValid)
    }
    
    private func handleTextFieldChange(index: Int, newValue: String) {
        if newValue.isEmpty {
            moveToPreviousField(index: index)
        } else {
            viewModel.yearDigits[index] = String(newValue.prefix(1))
            moveToNextField(index: index)
        }
        
        updateCombinedYear()
        if isYearComplete() { validateYear() }
        
        // update can go next status
        viewModel.canGoNext[3] = isYearComplete() && viewModel.isYearValid
    }
    
    private func createWarningLabel() -> some View {
        HStack(spacing: 6) {
            if isYearComplete() && !viewModel.isYearValid {
                WarningLabel(errorText: "유효한 년도를 입력해주세요.")
            }
        }
        .foregroundStyle(.primary3)
        .frame(maxWidth: .infinity)
        .frame(height: 23)
        .padding(.top, 23)
    }
    
    private func moveToNextField(index: Int) {
        focusedField = (index < 3) ? index + 1 : nil
    }
    
    private func moveToPreviousField(index: Int) {
        focusedField = (index > 0) ? index - 1 : 0
    }
    
    private func isYearComplete() -> Bool {
        return viewModel.yearDigits.allSatisfy { $0.count == 1 }
    }
    
    private func validateYear() {
        let yearString = viewModel.yearDigits.joined()
        if let year = Int(yearString), (1950...Calendar.current.component(.year, from: Date())).contains(year) {
            viewModel.isYearValid = true
        } else {
            viewModel.isYearValid = false
        }
    }
    
    private func updateCombinedYear() {
        viewModel.combinedYear = viewModel.yearDigits.joined()
        BBIPLogger.log("CombinedYear: \(viewModel.combinedYear)", level: .debug, category: .viewModel)
    }
}

fileprivate extension View {
    func underlineView(isActive: Bool, isError: Bool) -> some View {
        self
            .padding(.bottom, 10)
            .overlay(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(isActive ? .primary3 : .gray3),
                alignment: .bottom
            )
    }
}
