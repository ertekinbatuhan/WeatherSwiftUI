//
//  ContentView.swift
//  Weather App
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel = WeatherViewModel()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    SearchBar(text: $searchText, onSearchTapped: {
                        viewModel.fetchWeather(for: searchText)
                    })
                    Spacer()
                    
                    if viewModel.name.isEmpty {
                        Text("Loading...")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    } else {
                        WeatherCardView(viewModel: viewModel)
                            .frame(width: 350, height: 600)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(20)
                            .padding()
                    }
                }
            }
            .onAppear {
                viewModel.fetchWeather()
            }
            .navigationTitle(viewModel.name)
        }
    }
}


struct WeatherCardView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            if let url = URL(string: "https://openweathermap.org/img/wn/\(viewModel.icon).png") {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150) 
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom, 10)
            }
            
            Text(viewModel.description.capitalized)
                .font(.title2)
                .foregroundColor(.black)
            
            Text(viewModel.temp.formattedTemperature())
                .font(.system(size: 48))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "wind")
                            .foregroundColor(.blue)
                        Text(viewModel.windSpeed.formattedWindSpeed())
                            .foregroundColor(.black)
                    }
                    HStack {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.green)
                        Text("\(viewModel.humidity)%")
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "thermometer.sun")
                            .foregroundColor(.orange)
                        Text(viewModel.maxTemp.formattedTemperature())
                            .foregroundColor(.black)
                    }
                    HStack {
                        Image(systemName: "thermometer.snowflake")
                            .foregroundColor(.blue)
                        Text(viewModel.minTemp.formattedTemperature())
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.8))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding()
    }
}

struct SearchBar: View {
    
    @Binding var text: String

    var onSearchTapped: () -> Void

    var body: some View {
        HStack {
            TextField("Search city...", text: $text, onCommit: onSearchTapped)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                onSearchTapped()
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
            .padding(.trailing)
        }
        .padding(.top, 10)
    }
}


#Preview {
    
    HomeView()
}
