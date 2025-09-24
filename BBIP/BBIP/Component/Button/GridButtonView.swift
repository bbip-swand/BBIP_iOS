//
//  GridButtonView.swift
//  BBIP
//
//  Created by 이건우 on 8/27/24.
//

import SwiftUI

enum GridButtonViewType {
    case interest   // 관심사, 카테고리
    case job        // 직업
}

struct GridButtonView: View {
    @Binding var selectedIndices: [Int]
    private let maximumCount: Int   // 중복 선택 최대 개수
    private let isDarkMode: Bool      // 스터디 생성 시 사용되는 다크모드
    
    private let type: GridButtonViewType
    private var contents: [GridButtonContent] {
        switch type {
        case .interest:
            GridButtonContent.generateInterestContent()
        case .job:
            GridButtonContent.generateJobContent()
        }
    }
    
    private var gridItems: [GridItem] {
        switch type {
        case .interest:
            Array(repeating: .init(.flexible(), spacing: 8), count: 3)
        case .job:
            Array(repeating: .init(.fixed(135), spacing: 16), count: 2)
        }
    }
    
    private var imageSize: CGFloat {
        switch type {
        case .interest:
            54
        case .job:
            60
        }
    }
    
    // MARK: - Colors
    private var backgroundColor: Color {
        isDarkMode ? .gray8 : .mainWhite
    }
    
    private var selectedBackgroundColor: Color {
        isDarkMode 
        ? Color(uiColor: UIColor(hexCode: "FF9090", alpha: 0.5))
        : .primary1
    }
    
    private var textColor: Color {
        isDarkMode ? .gray1 : .gray7
    }
    
    private func process(with index: Int) {
        switch type {
        case .interest:
            if isDarkMode { // 스터디 생성 시 최대개수가 1개 이므로 로직 구분
                selectedIndices = [index]
            } else {
                if selectedIndices.contains(index) {
                    selectedIndices.removeAll { $0 == index }
                } else if selectedIndices.count < maximumCount {
                    selectedIndices.append(index)
                }
            }
        case .job:
            selectedIndices = [index]
        }
    }
    
    init(
        type: GridButtonViewType,
        selectedIndex: Binding<[Int]>,
        maximumCount: Int = 1,
        isDarkMode: Bool = false
    ) {
        self.type = type
        self._selectedIndices = selectedIndex
        self.maximumCount = maximumCount
        self.isDarkMode = isDarkMode
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            var itemWidth: CGFloat {
                switch type {
                case .interest:
                    (geometry.size.width - 16) / 3
                case .job:
                    135
                }
            }
            
            LazyVGrid(columns: gridItems, spacing: type == .interest ? 8 : 16) {
                ForEach(contents.indices, id: \.self) { index in
                    let content = contents[index]
                    
                    Button {
                       process(with: index)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    selectedIndices.contains(index)
                                    ? selectedBackgroundColor
                                    : (isDarkMode ? .gray8 : .mainWhite)
                                )
                            
                            VStack(spacing: 12) {
                                Image(content.imgName)
                                    .resizable()
                                    .frame(width: imageSize, height: imageSize)
                                
                                Text(content.text)
                                    .font(.bbip(.body2_m14))
                                    .foregroundStyle(textColor)
                            }
                        }
                        .frame(width: itemWidth, height: itemWidth)
                    }
                    .bbipShadow1()
                    .radiusBorder(
                        cornerRadius: 12,
                        color: .primary3,
                        lineWidth: selectedIndices.contains(index)
                        ? 2
                        : 0
                    )
                }
            }
        }
    }
}
