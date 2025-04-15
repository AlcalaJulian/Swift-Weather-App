
import SwiftUI

struct CityDetailView: View {
    @State private var viewModel: CityDetailViewModel
    @State private var isSHowingMap = false
    
    init(city: CityDto) {
        _viewModel = State(wrappedValue: CityDetailViewModel(city: city))
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                List {
                    CurrentTimeHeaderSectionView(viewModel: viewModel)
                    CurrentTimeSectionView(hourlyWeather: viewModel.hourlyWeather, currentDay: viewModel.currentDay, currentDate: viewModel.currentDate)
                    WeatherListSectionView(viewModel: viewModel)
                }
                
                .navigationTitle(viewModel.navigationTitle)
                
                .sheet(item: $viewModel.selectedOtherDay) { day in
                    VStack {
                        CurrentTimeSectionView(
                            hourlyWeather: day.hourly,
                            currentDay: day.day,
                            currentDate: day.day
                        )
                        Button {
                            viewModel.handleWeatherTap(for: nil)
                        } label: {
                            Text("OK")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .buttonStyle(.bordered)
                                .background(Color.blue)
                        }
                    }
                    .padding(.top, 15)
                    .padding([.horizontal, .bottom], 15)
                    .background(Color(UIColor.systemBackground), in: RoundedRectangle(cornerRadius: 15))
                    .shadow(color: Color.black.opacity(0.12), radius: 8)
                    .padding(.horizontal, 5)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
                    .presentationBackgroundInteraction(.enabled(upThrough: .height(400)))
                }

                /*
                .sheet(isPresented: $isSHowingMap) {
                    ZStack {
                        MapView(city: viewModel.city)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            MapCard(city: viewModel.city)
                                .shadow(color: .black.opacity(0.7), radius: 20)
                                .padding()
                        }
                    }
                    .ignoresSafeArea()
                    .overlay(alignment: .topLeading) {
                        BackButtonView(onClick: { isSHowingMap.toggle() })
                    }
                }
                 */
            }

            VStack {
                HStack {
                    Spacer()
                    
                    if !viewModel.city.isFavorite {

                            Image(systemName: "star.fill")
                            .foregroundColor(.gray)
                                .padding(10)
                                .font(.title).onTapGesture {
                                    Task{
                                        await  viewModel.addToFavorites()
                                    }
                                }
                    }

                    if viewModel.city.isFavorite {

                            Image(systemName: "star.fill")
                                .foregroundColor(.blue)
                                .padding(10)
                                .font(.title)
                                .onTapGesture {
                                    Task{
                                        await viewModel.removeFromFavorites()
                                    }
                                }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}
