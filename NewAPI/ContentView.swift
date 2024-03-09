import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var vm = ListingPublisherViewModel()
    @State private var showingSheet = false
    @State private var destinationSearchView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            NavigationView {
                ScrollView {
                    ForEach(vm.results, id: \.ListingKey) { listing in
                        NavigationLink {
                            NavigationLazyView(PopDestDetailsView(value: listing))
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    AsyncImage(url: URL(string: listing.Media?.first?.MediaURL ?? "")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .aspectRatio(contentMode: .fill)
                                            .clipped()
                                            .ignoresSafeArea()
                                            .overlay(alignment: .bottom) {
                                                ImageOverlayView(listing: listing)
                                            }
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                
                                ListingRowView(listing: listing)
                                
                                HStack(alignment: .center) {
                                    ListingDetailsView(listing: listing, showingSheet: $showingSheet)
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom)
                    }
                }
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
            }
        }
        .task {
            await vm.fetchProducts()
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
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(listing.ListAgentFullName ?? "")
                .font(.system(size: 16, weight: .regular))
            
//            HStack {
//                Text(listing.MlsStatus ?? "")
//                    .font(.system(size: 16, weight: .medium))
//                    .foregroundColor(Color(.tertiaryLabel))
//            
//            }
            
            Button("VIEW DETAILS") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                PopDestDetailsView(value: listing)
            }
            
//            HStack {
//                Text(listing.ListPrice ?? 0, format: .currency(code: "USD"))
//                    .font(.system(size: 14, weight: .regular))
//                Text(listing.formattedLaunchDate)
//                    .font(.system(size: 14, weight: .regular))
//            }
            .padding(.horizontal)
        }
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
