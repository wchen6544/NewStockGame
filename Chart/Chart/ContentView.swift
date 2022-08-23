//
//  ContentView.swift
//  Chart
//
//  Created by Wilson Chen on 8/15/22.
//

import SwiftUI
struct ContentView: View {

    
    //let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
            
        TabView {

            HomeView()
                .tabItem() {
                    Image(systemName: "phone.fill")
                    Text("calls")
                    
                }
            
            
            StockView()
                .tabItem() {
                    Image(systemName: "chart.bar")
                    Text("Trade")
                }
            
            
            PortfolioView()
                .tabItem() {
                    Image(systemName: "chart.pie")
                    Text("Portfolio")
                }
            
            
        }


    }
    
        
}

