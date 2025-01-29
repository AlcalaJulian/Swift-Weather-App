//
//  SplashScreen.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 21/1/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var size = 0.8
    @State private var opacity = 0.5
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Color.black : Color.white)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image("storm_logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Text("Weather")
                    .font(.system(size: 26))
                    .foregroundStyle(colorScheme == .dark ? Color.white : Color.black) 
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
