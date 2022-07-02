//
//  ControlImageView.swift
//  Pinch
//
//  Created by Manuel Martinez on 02/07/22.
//

import SwiftUI

struct ControlImageView: View {
    
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 30))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "plus")
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
