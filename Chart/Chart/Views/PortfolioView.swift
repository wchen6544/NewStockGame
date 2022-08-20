//
//  PortfolioView.swift
//  Chart
//
//  Created by Wilson Chen on 8/18/22.
//

import SwiftUI

struct PortfolioView: View {

    let data: [Double]
    let dates: [String]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    
    @State public var backgroundColor: Color = ColorConvert().convertColor(hexString: "#0A0A0F")
    @State public var textColor: Color = ColorConvert().convertColor(hexString: "#EDF2F4")
    @State public var buttonColor = ColorConvert().convertColor(hexString: "#2D4EC3")

    
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
        
        let allData = apiCalls.getDataPointsPortfolio()
        
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
        
        NavigationView {
            
            ScrollView {
                
                ZStack {
                    
                    ColorConvert().convertColor(hexString: "#0A0A0F")
                    
                    VStack (alignment: .leading, spacing: 0) {
                        
                                                        
                        userStockData
                            .padding(.top, -50)
                        
                            //.border(Color.red, width: 1)
                        
                        HStack (spacing: 0) {
                        
                            Text("Holding")
                                .padding([.vertical], 50)
                                .font(.system(size: 25, weight: .bold, design: .default))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                               // .border(Color.red, width: 1)
                            Text("View all")
                                .padding(.trailing, 20)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                               // .border(Color.orange, width: 1)

                            
                        }
                        
                      //  .border(Color.green, width: 1)

                        

                        MainMenuButtonView(
                            symbol: "AAPL",
                            sharesOwned: "60 Shares",
                            value: "$731.11",
                            stockPrice: "$173.11 ea.",
                            width: width,
                            chartComponent:  chartComponent
                        )
                        
                        Spacer().frame(height: 20)
                        MainMenuButtonView(
                            symbol: "AAPL",
                            sharesOwned: "60 Shares",
                            value: "$731.11",
                            stockPrice: "$173.11 ea.",
                            width: width,
                            chartComponent:  chartComponent

                        )
                        Spacer().frame(height: 20)
                        MainMenuButtonView(
                            symbol: "AAPL",
                            sharesOwned: "60 Shares",
                            value: "$731.11",
                            stockPrice: "$173.11 ea.",
                            width: width,
                            chartComponent:  chartComponent

                        )
                        Spacer().frame(height: 20)
                        MainMenuButtonView(
                            symbol: "AAPL",
                            sharesOwned: "60 Shares",
                            value: "$731.11",
                            stockPrice: "$173.11 ea.",
                            width: width,
                            chartComponent:  chartComponent

                        )

                    }
                    
                }
                .edgesIgnoringSafeArea(.all)
              //  .border(Color.white, width: 1)
                
            }
            .background(backgroundColor.ignoresSafeArea(.all))

        }
        .background(backgroundColor.ignoresSafeArea(.all))

        
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
                        Text("+1431.01")
                        
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

struct MainMenuButtonView<Content: View>: View {

    var symbol: String
    var sharesOwned: String
    var value: String
    var stockPrice: String
    var width: CGFloat
    @ViewBuilder var chartComponent: Content
    
    
    init(symbol: String, sharesOwned: String, value: String, stockPrice: String, width: CGFloat, chartComponent: Content) {
        self.symbol = symbol // assign all the parameters, not only `content`
        self.sharesOwned = sharesOwned
        self.value = value
        self.stockPrice = stockPrice
        self.width = width
        self.chartComponent = chartComponent
    }
    
    
    var body: some View {

        HStack {
        
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(ColorConvert().convertColor(hexString: "#131319"), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 5).fill(ColorConvert().convertColor(hexString: "#131319")))
                    .frame(width: width - 40, height: 80)
                
                HStack {
                    
                    VStack (alignment: .leading) {
                        
                        Text(symbol)
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
                        
                        Text(sharesOwned)
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 5.0, trailing: 0.0))
                            .foregroundColor(ColorConvert().convertColor(hexString: "#A1A1A3"))
                        
                    }
                    .frame(width: (width - 120) / 2, height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    chartComponent
                    
                    VStack (alignment: .trailing) {
                        
                        Text(value)
                            .font(.system(size: 15, weight: .bold, design: .default))
                            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 1.0, trailing: 0.0))
                        Text(stockPrice)
                            .font(.system(size: 12, weight: .bold, design: .default))
                            .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 5.0, trailing: 0.0))
                            .foregroundColor(ColorConvert().convertColor(hexString: "#A1A1A3"))
                    }
                    .frame(width: (width - 120) / 2, height: 50)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                }
            }
            Spacer()
        }
    }
}


extension PortfolioView {
    
    private var chartComponent: some View {
        ZStack {
            
            GeometryReader { geometry in
                
                chartView
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

extension PortfolioView {
    private var chartView: some View {
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
        }
    }
    

    
}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
        
    }
}
