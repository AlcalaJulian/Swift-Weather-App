import SwiftUI

struct MapCard: View {
    @EnvironmentObject private var settings: SettingsStore
    var city: CityDto

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.gray.opacity(0.6)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(radius: 4)

                    Text(tempString)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(city.city)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)

                    HStack {
                        Label("\(city.location.latitude, specifier: "%.2f")", systemImage: "location.north.fill")
                        Label("\(city.location.longitude, specifier: "%.2f")", systemImage: "location")
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
        )
        .padding(.horizontal)
    }

    private var tempString: String {
        if let current = city.getCurrentWeatherHour() {
            return settings.temp(Double(current.temperature))
        }
        return "--"
    }
}

