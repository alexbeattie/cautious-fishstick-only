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
        VStack {
            HStack(alignment: .bottom, spacing: 8) {
                HStack() {
                    Label("\(listing.BedroomsTotal ?? 0) Beds", systemImage: "bed.double")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                        
                }
                
                
                HStack(alignment: .center) {
                    Label("\(listing.BathroomsTotalInteger ?? 0) Baths", systemImage: "bathtub")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                HStack(alignment: .center) {
                    Text("\(listing.BuildingAreaTotal ?? 0) sqft")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }
            }.padding(.horizontal)
        }
        VStack(alignment: .leading){
            HStack() {
                Text("\(listing.StreetNumber ?? "")")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                Text("\(listing.StreetName ?? "")")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
              
            }
            HStack() {
                Text("\(listing.City ?? ""),")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                Text("\(listing.StateOrProvince ?? "")")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
            }
//            Text(AttributedString(listing.UnparsedAddress ?? ""))
//                .font(.system(size: 14, weight: .regular))
//                .foregroundColor(Color(.label))
//                .minimumScaleFactor(0.01)
//                .lineLimit(1)
        }
        .padding(.horizontal)
    }
}
