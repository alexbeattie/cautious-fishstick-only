import SwiftUI
import Combine
import Kingfisher

//class ListingSelectionViewModel: ObservableObject {
//    @Published var selectedListing: Value?
////    @Published var showDetails: Bool = false
//}
struct ContentView: View {
    @StateObject var vm = ListingPublisherViewModel()
    @State private var selectedListing: Value?
//    @StateObject private var viewModel = ListingPublisherViewModel()
//    @StateObject private var selectionViewModel = ListingSelectionViewModel()
                    
    @State private var showDetails = false
    @State private var isLoading = true
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        ForEach(vm.results) { listing in
                            
                            VStack() {
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
                            }
                            Button(action: {
                                
                                selectedListing = listing
                                //                                    selectionViewModel.showDetails = true
                            }) {
                                HStack {
                                    VStack {
                                        
                                        ListingRowView(listing: listing)
                                    }
                                }
                                
                            }
                            HStack {
                                VStack {
                                    ListingDetailsView(listing: listing, selectedListing: $selectedListing, showDetails: $showDetails)
                                }
                            }
                            
                            .padding(.bottom)
                        }
                        
                    }
                    .ignoresSafeArea()
                    .preferredColorScheme(.dark)
                }
            }
        }
        .sheet(isPresented: $showDetails) {
            self.sheetContent()
        }
        .task {
            await vm.fetchProducts()
            isLoading = false
        }
    }
        
        @ViewBuilder
        private func sheetContent() -> some View {
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
        VStack(alignment: .leading) {
            Text(listing.ListAgentFullName ?? "")
                .font(.system(size: 16, weight: .regular))

            
            Button("VIEW DETAILS") {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("Button tapped, listing: \(listing.ListingKey ?? "N/A")")
                
                selectedListing = listing
                
                showDetails = (selectedListing != nil)
                print("showDetails set to \(showDetails)")

                //                }
                //                showingSheet.toggle()
            }
//            .sheet(isPresented: $showDetails) {
//                PopDestDetailsView(value: listing)
//            }

            .padding(.horizontal)
        }
//        .onAppear {
//                  if selectedListing == listing {
//                      showDetails = true
//                  }
//              }
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    var body: Content {
        build()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
