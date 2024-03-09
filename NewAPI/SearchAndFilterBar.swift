//
//  SearchAndFilterBar.swift
//  NewAPI
//
//  Created by Alex Beattie on 11/3/23.
//

import SwiftUI

struct SearchAndFilterBar: View {
    var body: some View {
        HStack {
            Label("", systemImage: "magnifyingglass")
            VStack (alignment: .leading, spacing: 0) {
                Text("Where to")
                Text("Anywhere - Any Week - Add Guests")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundStyle(.black)
            })
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .overlay {
            Capsule().stroke(lineWidth: 0.5)
                .foregroundStyle(Color(.systemGray4))
                .shadow(color: .black.opacity(0.4), radius: 2)
        }
        .padding()
    }
}

#Preview {
    SearchAndFilterBar()
}
