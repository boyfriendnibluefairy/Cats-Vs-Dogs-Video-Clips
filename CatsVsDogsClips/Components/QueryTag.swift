//
//  QueryTag.swift selects between
//  Cats and Dogs query string
//

import SwiftUI

struct QueryTag: View {
    
    var query:Query
    var isSelected:Bool
    
    var body: some View {
        // thinMaterial is similar to a blur background
        Text(query.rawValue)
            .font(.largeTitle)
            .bold()
            .foregroundColor(isSelected ? .black : .gray)
            .padding(16)
            .background(.thinMaterial)
            .cornerRadius(19)
    }
}

#Preview {
    QueryTag(query: Query.dog, isSelected: true)
}
