//
//  ListingImageCarouselView.swift
//  NewAPI
//
//  Created by Alex Beattie on 10/24/23.
//

import SwiftUI
import Kingfisher
struct ListingImageCarouselView: View {
//    let vm:ListingPublisherViewModel
//    var image = [Media]()
//    let value:[Value]
//    let media: [Value.Media]!

    var images = ["https://cdn.photos.sparkplatform.com/vc/20210901050900400130000000-o.jpg", "https://cdn.photos.sparkplatform.com/vc/20210901054953957066000000-o.jpg", "https://cdn.photos.sparkplatform.com/vc/20210901050926435414000000-o.jpg", "https://cdn.photos.sparkplatform.com/vc/20211007000043973526000000-o.jpg"]
//    init(value: Value, media: [Value.Media]) {
//        self.value = [value]
//        self.media = value.Media.map { $0 }
//        
//    }
    var body: some View {
        TabView {
//            ForEach(media, id: \.MediaKey) { media in
//                
//                KFImage(URL(string: (media.MediaURL ?? "")))
//                    .resizable()
//                    .scaledToFit()
//            }
//            ForEach(vm.media, id: \.MediaKey) { photos in
//                KFImage(URL(string: image.first?.MediaURL ?? "alex"))
//            }
            ForEach(images, id: \.self) { image in
                KFImage(URL(string: image))
                    .resizable()
                    .scaledToFit()
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ListingImageCarouselView()
}
