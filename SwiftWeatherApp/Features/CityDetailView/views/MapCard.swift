//
//  MapCard.swift
//  SwiftWeatherApp
//
//  Created by Johan Charles on 20/1/25.
//

import SwiftUI
/*
struct MapCard: View {
    
    var city: CityDto
    
    var body: some View{
        VStack{
            HStack{
                
                ZStack{
                    if let temp = city.getCurrentWeatherHour()?.temperature{
                        Image(systemName: "\(temp).square.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .background(.white)
                        }
                    else
                        {
                            city.getCurrentWeatherHour()?
                                .getConditionIcon()
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .background(.white)
                        }
                    
                    
                        
                }
                .padding(6)
                .background(.white)
                .cornerRadius(10)
                
                
                VStack{
                    
                        Text(city.city)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                        
                            Text("Latitude: " + String(city.location.latitude))
                                .font(.subheadline)
                            Text("Longitude: " + String(city.location.longitude))
                                .font(.subheadline)
                    }
                
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 35)
        ).cornerRadius(10)
    }
}
*/
