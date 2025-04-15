import SwiftUI

struct CityRow: View {
    let city: CityDto
    
    var body: some View {
        CityRowContentView(
            city: city,
            condition: city.currentWeather.condition,
            currentTemp: city.currentWeather.temp,
            feelsLike: city.currentWeather.feelsLike,
            humidity: city.currentWeather.humidity
        )
    }
}

struct CityRowContentView: View {
    let city: CityDto
    let condition: String
    let currentTemp: Double
    let feelsLike: Double
    let humidity: Int
    
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundGradient: LinearGradient {
        let startColor = colorScheme == .dark ? Color.blue.opacity(0.6) : Color.blue.opacity(0.4)
        let endColor = colorScheme == .dark ? Color.gray.opacity(0.7) : Color(.lightGray).opacity(0.7)
        return LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }
    
    var leftContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(city.city)
                .font(.system(size: 22))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text(condition.capitalized)
                .font(.system(size: 16))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.9) : .black.opacity(0.9))
        }
        .padding(.leading, 16)
    }
    
    var rightContent: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("\(currentTemp, specifier: "%.0f")°")
                .font(.system(size: 48))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Text("Sensación: \(feelsLike, specifier: "%.0f")°")
                .font(.system(size: 14))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : .black.opacity(0.85))
            Text("Humedad: \(humidity)%")
                .font(.system(size: 14))
                .foregroundColor(colorScheme == .dark ? .white.opacity(0.85) : .black.opacity(0.85))
        }
        .padding(.trailing, 16)
    }
    
    var body: some View {
        HStack {
            leftContent
            Spacer()
            rightContent
        }
        .padding(.vertical, 16)
        .background(backgroundGradient)
        .cornerRadius(12)
    }
}

struct CityRowFallbackView: View {
    let city: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack {
            Text(city)
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .white : .gray)
            Spacer()
            Text("Sin datos meteorológicos")
                .font(.subheadline)
                .foregroundColor(colorScheme == .dark ? .white : .gray)
        }
        .padding()
        .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
