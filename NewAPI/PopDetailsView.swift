import SwiftUI
import MapKit
import Kingfisher




struct PopDestDetailsView: View {
    
    
 

    
    let value: Value
    let showDismissButton: Bool
    @Binding var showDetails: Bool
    
    @State private var selectedAnnotation: MKAnnotation?
//    @State private var presentAlert = false
    @State private var directionsMapItem: MKMapItem?
    @State private var showDirections = false
    @State private var region: MKCoordinateRegion
    @State private var isFullScreen = false
    @Environment(\.presentationMode) var presentationMode
    
    init(value: Value, showDismissButton: Bool, showDetails: Binding<Bool> = .constant(false)) {
        self.value = value
        self.showDismissButton = showDismissButton
        self._showDetails = showDetails
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: value.Latitude ?? 0, longitude: value.Longitude ?? 0), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    var body: some View {
        ZStack (alignment: .topLeading){
            ScrollView(showsIndicators: false) {
                VStack {
                    if showDirections {
                        DirectionsView(mapItem: directionsMapItem!)
                            .frame(height: 200)
                    }
                
                    ImageCarouselView(media: value.Media ?? [])
                        .frame(height: 320)
                    
                    PropertyDetailsView(value: value)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    WebsiteLinkView(value: value)
                    PropertyDescriptionView(value: value)
                        .padding()
                    
                    Divider()
                    
//                    FullScreenMapToggle(isFullScreen: $isFullScreen)
//                        .padding()
                    
                    MapView(value: value, selectedAnnotation: $selectedAnnotation, directionsMapItem: $directionsMapItem)
                        .frame(height: isFullScreen ? UIScreen.main.bounds.height : 200)
                        .edgesIgnoringSafeArea(isFullScreen ? .all : [])
                }
//                .alert(isPresented: $presentAlert) {
//                        Alert(
//                            title: Text("Get Directions"),
//                                          message: Text("Do you want to get directions to the selected location?"),
//                                          primaryButton: .default(Text("Show Directions")) {
//                                              showDirections = true
//                                          },
//                            secondaryButton: .cancel()
//                        )
//                    }
            }
//            .transition(.slide)
            if showDismissButton {
                Button(action: {
                    // Dismiss the sheet
                    showDetails = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .light))
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
                .offset(x: 15, y: 15)
            }
        }
        .edgesIgnoringSafeArea(.all)
//        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    }
}
struct DirectionsView: UIViewRepresentable {
    let mapItem: MKMapItem
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mapView.addOverlay(route.polyline)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
        }
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DirectionsView
        
        init(_ parent: DirectionsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct ImageCarouselView: View {
    let media: [Value.Media]
    
    var body: some View {
        TabView {
            ForEach(media, id: \.MediaKey) { media in
                KFImage(URL(string: media.MediaURL ?? "")).cacheMemoryOnly()
                    .resizable()
                    .scaledToFill()
            }
        }
        .tabViewStyle(.page)
    }
}



struct PropertyDetailsView: View {
    let value: Value
    
    var body: some View {
        
        VStack {
            HStack(alignment: .bottom, spacing: 8) {
                VStack (alignment: .leading){
                HStack {
                    Text("$\(value.ListPrice ?? 0)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
            }
                
                HStack {
                    Label("\(value.BedroomsTotal ?? 0) Beds", systemImage: "bed.double")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Label("\(value.BathroomsTotalInteger ?? 0) Baths", systemImage: "bathtub")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("\(value.BuildingAreaTotal ?? 0) sqft")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
            }
//            .padding(.horizontal)
        }       
//        .ignoresSafeArea()

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
       
//struct FullScreenMapToggle: View {
//    @Binding var isFullScreen: Bool
//    
//    var body: some View {
//        Toggle("Full Screen", isOn: $isFullScreen)
//    }
//}

struct MapView: UIViewRepresentable {
    let value: Value
//    let isFullScreen: Bool
    @Binding var selectedAnnotation: MKAnnotation?
//    @Binding var presentAlert: Bool
    @Binding var directionsMapItem: MKMapItem?
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ view: MapViewWithOverlay, context: Context) {
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
    
    func makeUIView(context: Context) -> MapViewWithOverlay {
        let mapView = MapViewWithOverlay(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            parent.selectedAnnotation = annotation
            
            let placemark = MKPlacemark(coordinate: annotation.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = annotation.title ?? ""
            
//            parent.presentAlert = true
            parent.directionsMapItem = mapItem
            
            //               let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            //               mapItem.openInMaps(launchOptions: launchOptions)
        }
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            parent.selectedAnnotation = nil
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
                
                if let mediaURL = parent.value.Media?.first?.MediaURL, let url = URL(string: mediaURL) {
                    leftIconView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.transition(.fade(0.2))], completionHandler: { result in
                        switch result {
                        case .success(_):
                            annotationView?.leftCalloutAccessoryView = leftIconView
                        case .failure(_):
                            leftIconView.image = UIImage(named: "placeholder")
                            annotationView?.leftCalloutAccessoryView = leftIconView
                        }
                    })
                } else {
                    leftIconView.image = UIImage(named: "placeholder")
                    annotationView?.leftCalloutAccessoryView = leftIconView
                }
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
    class MapViewWithOverlay: MKMapView {
        func rendererFor(overlay: MKOverlay) -> MKOverlayRenderer? {
            if let polylineOverlay = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polylineOverlay)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return rendererFor(overlay: overlay)
        }
    }
}

