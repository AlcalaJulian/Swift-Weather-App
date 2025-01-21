//
//  BackButtonView.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 20/1/25.
//

import SwiftUI

struct BackButtonView: View {
    var onClick:() -> Void
    
    var body: some View {
        Button{
            onClick()
        } label: {
            
            Image(systemName:"xmark")
              .font(.headline)
               .padding(16)
               .foregroundColor(.red)
               .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}

#Preview {
    BackButtonView(onClick: { })
}
