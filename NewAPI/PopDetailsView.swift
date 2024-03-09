import SwiftUI
import MapKit
import Kingfisher

struct PopDestDetailsView: View {
    let value: Value
    
    @State private var region: MKCoordinateRegion
//    @Environment(\.dismiss) var dismiss
    @State private var isFullScreen = false
    

    init(value: Value) {
        self.value = value
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: value.Latitude ?? 0, longitude: value.Longitude ?? 0), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ImageCarouselView(media: value.Media ?? [])
                    .frame(height: 320)
                
                PropertyDetailsView(value: value)
                    .padding(.horizontal)
                
                Spacer()
                
                WebsiteLinkView(value: value)
                
                PropertyDescriptionView(value: value)
                    .padding()
                
                Divider()
                
                FullScreenMapToggle(isFullScreen: $isFullScreen)
                    .padding()
                MapView(value: value, isFullScreen: isFullScreen)
                    .frame(height: isFullScreen ? UIScreen.main.bounds.height : 200)
                    .edgesIgnoringSafeArea(isFullScreen ? .all : [])
            
            }
            .ignoresSafeArea()
        }
        .transition(.slide)
    }


}

struct ImageCarouselView: View {
    let media: [Value.Media]
    
    var body: some View {
        TabView {
            ForEach(media, id: \.MediaKey) { media in
                KFImage(URL(string: media.MediaURL ?? ""))
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(.page)
//        .overlay(alignment: .topLeading) {
//            DismissButton()
//                .padding(62)
//        }
    }
}



struct PropertyDetailsView: View {
    let value: Value
    
    var body: some View {
        
        HStack(alignment: .bottom) {
            PropertyDetailItem(title: "$\(value.ListPrice ?? 0)", subtitle: "Price")
            Spacer()
            PropertyDetailItem(title: "\(value.BedroomsTotal ?? 0)", subtitle: "Beds", imageName: "bed.double")
            Spacer()
            PropertyDetailItem(title: "\(value.BathroomsTotalInteger ?? 0)", subtitle: "Baths", imageName: "bathtub")
            Spacer()
            PropertyDetailItem(title: "\(value.BuildingAreaTotal ?? 0)", subtitle: "Sq Feet")
        }
        .ignoresSafeArea()

    }

}

struct PropertyDetailItem: View {
    let title: String
    let subtitle: String
    let imageName: String?
    
    init(title: String, subtitle: String, imageName: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.label))
            
            if let imageName = imageName {
                Label(subtitle, systemImage: imageName)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            } else {
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct WebsiteLinkView: View {
    let value: Value
    
    var body: some View {
        HStack {
            if let firstMedia = value.Media?.first, firstMedia.MediaCategory == "Document", let mediaURL = firstMedia.MediaURL {
                Link("Website", destination: URL(string: mediaURL)!)
            }
        }
    }
}

struct PropertyDescriptionView: View {
    let value: Value
    @State private var expandedAmenities = false
    @State private var expandedCommunityFeatures = false
    @State private var expandedLotFeatures = false
    @State private var expandedDisclosures = false

    var body: some View {
        VStack(alignment: .leading) {
            
            Text(value.MlsStatus ?? "")
                .font(.system(size: 14, weight: .heavy))
            
            Text(value.PublicRemarks ?? "")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
   
        ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 16) {
                        if let amenities = value.AssociationAmenities, !amenities.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Association Amenities")
                                    .font(.subheadline)
                                
                                ForEach(expandedAmenities ? amenities : Array(amenities.prefix(3)), id: \.self) { amenity in
                                    Text(amenity)
                                }
                                
                                if amenities.count > 3 {
                                    Button(action: {
                                        expandedAmenities.toggle()
                                    }) {
                                        Text(expandedAmenities ? "Show Less" : "Show More")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .frame(width: 200)
                        }
                        
                        if let communityFeatures = value.CommunityFeatures, !communityFeatures.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Community Features")
                                    .font(.subheadline)
                                
                                ForEach(expandedCommunityFeatures ? communityFeatures : Array(communityFeatures.prefix(3)), id: \.self) { feature in
                                    Text(feature)
                                }
                                
                                if communityFeatures.count > 3 {
                                    Button(action: {
                                        expandedCommunityFeatures.toggle()
                                    }) {
                                        Text(expandedCommunityFeatures ? "Show Less" : "Show More")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .frame(width: 200)
                        }
                        
                        if let lotFeatures = value.LotFeatures, !lotFeatures.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Lot Features")
                                    .font(.callout)
                                
                                ForEach(expandedLotFeatures ? lotFeatures : Array(lotFeatures.prefix(3)), id: \.self) { feature in
                                    Text(feature)
                                        .font(.subheadline)
                                }
                                
                                if lotFeatures.count > 3 {
                                    Button(action: {
                                        expandedLotFeatures.toggle()
                                    }) {
                                        Text(expandedLotFeatures ? "Show Less" : "Show More")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .frame(width: 200)
                        }
                        
                        if let lotDisclosures = value.Disclosures, !lotDisclosures.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Disclosures")
                                    .font(.callout)
                                
                                ForEach(expandedDisclosures ? lotDisclosures : Array(lotDisclosures.prefix(3)), id: \.self) { disclosure in
                                    Text(disclosure)
                                        .font(.subheadline)
                                }
                                
                                if lotDisclosures.count > 3 {
                                    Button(action: {
                                        expandedDisclosures.toggle()
                                    }) {
                                        Text(expandedDisclosures ? "Show Less" : "Show More")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .frame(width: 200)
                        }
                    }
                }
            }
        }
}
       
struct FullScreenMapToggle: View {
    @Binding var isFullScreen: Bool
    
    var body: some View {
        Toggle("Full Screen", isOn: $isFullScreen)
    }
}

struct MapView: UIViewRepresentable {
    let value: Value
    let isFullScreen: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = .hybrid
        view.delegate = context.coordinator
        
        let coordinate = CLLocationCoordinate2D(latitude: value.Latitude ?? 0, longitude: value.Longitude ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = value.UnparsedAddress
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        annotation.subtitle = numberFormatter.string(from: NSNumber(value: value.ListPrice ?? 0))
        
        view.addAnnotation(annotation)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }
            
            let annotationIdentifier = "AnnotationIdentifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
                annotationView?.canShowCallout = true
                
                let rightButton = UIButton(type: .detailDisclosure)
                rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                rightButton.setImage(UIImage(named: "small-pin-map-7"), for: .normal)
                annotationView?.rightCalloutAccessoryView = rightButton
                
                let leftIconView = UIImageView()
                leftIconView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                leftIconView.contentMode = .scaleAspectFill
                leftIconView.clipsToBounds = true
                leftIconView.kf.setImage(with: URL(string: "your-image-url"))
                annotationView?.leftCalloutAccessoryView = leftIconView
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
