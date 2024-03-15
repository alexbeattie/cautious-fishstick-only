//
//  ListingRowView.swift
//  NewAPI
//
//  Created by Alex Beattie on 3/6/24.
//

import Foundation


import SwiftUI

struct ListingRowView: View {
    let listing: Value // Assuming `Value` is your data model type
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center) {
                HStack {
                    Label("\(listing.BedroomsTotal ?? 0) Beds", systemImage: "bed.double")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                    Label("\(listing.BathroomsTotalInteger ?? 0) Baths", systemImage: "bathtub")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                    Text("\(listing.BuildingAreaTotal ?? 0) sqft")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                }
                
                
                VStack(alignment: .center) {
                    HStack {
                        Text("\(listing.StreetNumber ?? "") \(listing.StreetName ?? "") \(listing.City ?? ""),\(listing.StateOrProvince ?? "")")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
            }
            Spacer()

        }
    }
}
#if DEBUG
struct ListingRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListingRowView(listing: Value(
            //            id: "1",
            AssociationAmenities: [],
            CommunityFeatures: [],
            Disclosures: [],
            LotFeatures: [],
            BedroomsTotal: 3,
            StateOrProvince: "CA",
            City: "Anytown",
            
            BathroomsTotalInteger: 2,
            BuildingAreaTotal: 1500,
            StreetNumber: "123",
            StreetName: "Main St"
            
        ))
    }
}
#endif
