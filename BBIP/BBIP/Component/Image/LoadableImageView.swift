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
                        // loading placeholder
                        Image("logo_placeholder")
                            .resizable()
                            .scaledToFill()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .opacity(isLoaded ? 1 : 0)  // Smooth opacity animation
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.4)) { isLoaded = true }
                            }
                    case .failure:
                        // failed to load, fallback to placeholder
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
