//
//  SplachScreenView.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 21/1/25.
//

import SwiftUI

struct SplachScreenView: View {
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            Image("storm_logo")
                .resizable()
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    SplachScreenView()
}
