//
//  LoadableImageView.swift
//  BBIP
//
//  Created by 이건우 on 9/25/24.
//

import SwiftUI

struct LoadableImageView: View {
    @State private var isLoaded: Bool = false
    var imageUrl: String?
    var size: CGFloat
    
    init(
        imageUrl: String?,
        size: CGFloat = 60
    ) {
        self.imageUrl = imageUrl
        self.size = size
    }
    
    var body: some View {
        Group {
            if let url = imageUrl {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        // loading
                        Image("logo_placeholder")
                            .resizable()
                            .scaledToFill()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .opacity(isLoaded ? 1 : 0)  // 로딩 후 애니메이션 적용
                            .onAppear {
                                withAnimation(.easeIn(duration: 0.5)) { isLoaded = true }
                            }
                    case .failure:
                        // load fail
                        Image("logo_placeholder")
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("logo_placeholder")
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .onAppear {
            isLoaded = false
        }
    }
}

