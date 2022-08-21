//
//  ContentView.swift
//  Chart
//
//  Created by Wilson Chen on 8/15/22.
//

import SwiftUI
struct ContentView: View {
    
    let data: [Double]
    let dates: [String]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    
    @State public var backgroundColor: Color = ColorConvert().convertColor(hexString: "#0A0A0F")
    @State public var textColor: Color = ColorConvert().convertColor(hexString: "#EDF2F4")
    @State public var buttonColor = ColorConvert().convertColor(hexString: "#4928CE")

    
    let company: String
    let symbol: String
    let closedPrice: String
    
    var bounds = UIScreen.main.bounds
    var width: CGFloat
    var height: CGFloat
    
    @State private var percentage: CGFloat = 0
    @State public var map: [Double: Double]
    @State public var distances: [CGFloat]
    let apiCalls = API()
    
    
    init() {
        
        let allData = apiCalls.getDataPoints()
        
        data = allData.0
        dates = allData.1
        company = allData.2
        symbol = allData.3
        closedPrice = allData.4
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.green : Color.red

        
        width = bounds.size.width
        height = bounds.size.height
        
        let tmp = addToList(data: data, maxY: maxY, minY: minY, width: width, height: height)
        distances = tmp.1
        map = tmp.0
        
    }



    @State private var xV: Double = 0.0
    @State private var yV: Double = 0.0
    
    
    @State private var xVal: CGFloat = 0
    @State private var yVal: Double = 0.0
    
    @State var hoveredPrice: String = ""
    @State var hoveredDate: String = ""
    @State var currentPrice: String = ""
    @State var currentDate: String = ""
    
    @State var differenceSincePrevClose: String = ""
    
    @State var isHidden: Bool = false
    
    @State var pointColor: UIColor = UIColor.clear
    
    //let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
            
        TabView {
            
            PortfolioView()
                .tabItem() {
                    Image(systemName: "chart.pie")
                    Text("Portfolio")
                }
            
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
            

            
        }


    }
    
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}



