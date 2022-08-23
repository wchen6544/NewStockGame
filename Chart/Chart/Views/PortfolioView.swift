//
//  PortfolioView.swift
//  Chart
//
//  Created by Wilson Chen on 8/18/22.
//

import SwiftUI

struct PortfolioView: View {


    @State public var backgroundColor: Color = ColorConvert().convertColor(hexString: "#0A0A0F")
    @State public var textColor: Color = ColorConvert().convertColor(hexString: "#EDF2F4")
    @State public var buttonColor = ColorConvert().convertColor(hexString: "#2D4EC3")

    var bounds = UIScreen.main.bounds
    var width: CGFloat
    var height: CGFloat
  
    
    init() {
        width = bounds.size.width
        height = bounds.size.height
    }
    
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                ZStack {
                    
                    ColorConvert().convertColor(hexString: "#0A0A0F")
                    
                    VStack (alignment: .leading, spacing: 0) {
                                                        
                        userStockData
                            .padding(.top, -50)
                                                
                        HStack (spacing: 0) {
                        
                            Text("Holding")
                                .padding([.vertical], 50)
                                .font(.system(size: 25, weight: .bold, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                            Text("View all")
                                .padding(.trailing, 20)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                             
                        }
                        
                        Holding(
                            symbol: "AAPL",
                            sharesOwned: "60 Shares",
                            value: "$731.11",
                            stockPrice: "$173.11 ea.",
                            width: width,
                            chartComponent:  ChartComponent(symbol: "AAPL")
                        )
                        Spacer().frame(height: 20)
                        Holding(
                            symbol: "GOOG",
                            sharesOwned: "23 Shares",
                            value: "$2716.53",
                            stockPrice: "$118.11 ea.",
                            width: width,
                            chartComponent:  ChartComponent(symbol: "GOOG")
                        )
                        Spacer().frame(height: 20)
                        Holding(
                            symbol: "DELL",
                            sharesOwned: "21 Shares",
                            value: "$1001.07",
                            stockPrice: "$47.67 ea.",
                            width: width,
                            chartComponent:  ChartComponent(symbol: "DELL")
                        )
                        
                        Spacer().frame(height: 20)
                        Holding(
                            symbol: "TSLA",
                            sharesOwned: "5 Shares",
                            value: "$4450.05",
                            stockPrice: "$890.01 ea.",
                            width: width,
                            chartComponent:  ChartComponent(symbol: "TSLA")
                        )
                         

                    }
                    
                }
                .edgesIgnoringSafeArea(.all)
            }
            .background(backgroundColor.ignoresSafeArea(.all))
        }
        
        .preferredColorScheme(.dark) // makes top bar text white
    }
}

struct Portfolio_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
        
    }
}




extension PortfolioView {
    
    private var userStockData: some View {
        
        HStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ColorConvert().convertColor(hexString: "#2D4EC3").opacity(0.25), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 10).fill(ColorConvert().convertColor(hexString: "#131319")))
                    .frame(width: width - 40, height: 180)
                    .shadow(color: buttonColor, radius: 5, x: 0.0, y: 0.0)

                
                VStack (alignment: .leading) {
                    
                    Text("My Portfolio")
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundColor(ColorConvert().convertColor(hexString: "#3874DE"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
                    
                    Text("$164,461")
                        .font(.system(size: 35, weight: .bold, design: .default))
                        .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 5.0, trailing: 0.0))

                    HStack {
                        Text("+$1431.01")
                        
                        HStack (spacing: 0){
                            Image(systemName: "arrow.up")
                                .foregroundColor(ColorConvert().convertColor(hexString: "#36C03C"))
                                
                            Text("16%")
                                .foregroundColor(ColorConvert().convertColor(hexString: "#36C03C"))

                        }
                    }
                    .font(.system(size: 15, weight: .bold, design: .default))

                }
                .frame(width: width - 120, height: 120)
            }
            Spacer()
        }
    }
}


struct ChartComponent: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    
    let symbol: String
    
    var bounds = UIScreen.main.bounds
    var width: CGFloat
    var height: CGFloat
    
    @State private var percentage: CGFloat = 0
    @State var results = [API.ReturnData]()

    
    let apiCalls = API()
    
    init(symbol: String) {
        
        
        let allData = apiCalls.getDataPointsPortfolio(symbol: symbol)
        
        self.data = allData.0
        self.symbol = allData.1

        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.green : Color.red

        
        width = bounds.size.width
        height = bounds.size.height
        
        
    }
    
    
    var body: some View {
        
        ZStack {
            
            GeometryReader { geometry in
                
                Path { path in
                    
                    for index in data.indices {
                        
                        let xPosition = (((width / 4) / CGFloat(data.count)) * CGFloat(index + 1))
                        
                        let yAxis = maxY - minY
                        
                        let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * 40
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: xPosition, y: yPosition))
                        } else {
                            path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                        }
                    }
                }
                .trim(from: 0, to: percentage)
                .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                .shadow(color: lineColor, radius: 10, x: 0.0, y: 0.0)
                
                .frame(height: 400)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.linear(duration: 2.0)) { percentage = 1.0 }
                    }
                }
                .position(x: (geometry.size.width) / 3, y: 220)
            }
        }
        
    }
}
