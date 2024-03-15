import SwiftUI
import Combine
import Kingfisher

struct ContentView: View {
    @StateObject var vm = ListingPublisherViewModel()
    @State private var selectedListing: Value?
    @State private var showDetails = false
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        ForEach(vm.results, id: \.ListingKey) { listing in
                            VStack(alignment: .leading) {
                                HStack {
                                    KFImage(URL(string: listing.Media?.first?.MediaURL ?? ""))
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .ignoresSafeArea()
                                        .overlay(alignment: .bottom) {
                                            ImageOverlayView(listing: listing)
                                        }
                                }
                                
                                Button(action: {
                                    selectedListing = listing
                                    showDetails = true
                                }) {
//                                    ListingRowView(listing: listing)
                                    VStack(alignment: .center) {
                                            ListingDetailsView(listing: listing, selectedListing: $selectedListing, showDetails: $showDetails)
                                        
                                    }
                                    

                                }
//                                VStack(alignment: .center) {
//                                        ListingDetailsView(listing: listing, selectedListing: $selectedListing, showDetails: $showDetails)
//                                    
//                                }
                            }
                            .padding(.bottom)
                        }
                    }
                    .ignoresSafeArea()
                    .preferredColorScheme(.dark)
                }
            }
            .sheet(isPresented: $showDetails) {
                self.sheetContent()
            }
        }
        .task {
            await vm.fetchProducts()
            isLoading = false
        }
    }
    
    @ViewBuilder
    func sheetContent() -> some View {
        if let listing = selectedListing {
            PopDestDetailsView(value: listing, showDismissButton: true, showDetails: $showDetails)
        } else {
            EmptyView()
        }
    }
}

struct ImageOverlayView: View {
    let listing: Value
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text("$\(listing.ListPrice ?? 0)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                }
                Spacer()
                
                VStack {
                    Text("\(listing.Model ?? "")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.label))
                        .scaledToFit()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                }
                .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                Spacer()
                
                MlsStatusView(listing: listing)
                    .padding(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
                Spacer()
            }
        }
        .background(Color.black.opacity(0.5))
    }
}

struct MlsStatusView: View {
    let listing: Value
    
    var body: some View {
        VStack {
            if listing.MlsStatus == "Active" {
                Text(listing.MlsStatus ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(.label))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            } else if listing.MlsStatus == "Pending" || listing.MlsStatus == "Active Under Contract" {
                Text(listing.MlsStatus ?? "")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.red)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            } else {
                Text(listing.MlsStatus ?? "Unknown Status")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.gray)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            }
        }
    }
}

struct ListingDetailsView: View {
    let listing: Value
    @Binding var selectedListing: Value?
    @Binding var showDetails: Bool

    var body: some View {
        
        VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .center) {
                ListingRowView(listing: listing)
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: .infinity, minHeight: nil, idealHeight: nil, maxHeight: .infinity, alignment: .center)
            }
//            HStack(alignment: .center) {
                
                Text(listing.ListAgentFullName ?? "")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)

//            }
            Spacer()
        
        }

        HStack(alignment: .center) {
            
            HStack {
                VStack {
                    Button("VIEW DETAILS") {
                        selectedListing = listing
                        showDetails = true
                    }
                }
            }
        }

//        .padding(.horizontal)


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
