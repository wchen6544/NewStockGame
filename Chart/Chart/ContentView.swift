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
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        
        ZStack {
                    
            VStack (alignment: .leading, spacing: 0) {
                
                textBox
                chartComponent
                        
                Spacer().frame(height: 300)
                        
                userStockData
                customButtons
            }
        }
        .background(backgroundColor.ignoresSafeArea())
        .preferredColorScheme(.dark) // makes top bar text white

    }
    
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}



extension ContentView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                
                for index in data.indices {
                    
                    //let xPosition = (geometry.size.width) / CGFloat(data.count) * CGFloat(index + 1)
                    let xPosition = 16 + (((width - 32) / CGFloat(data.count)) * CGFloat(index + 1))

                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * 300
                    
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
        //.border(Color.orange, width: 1)
    }
    

    
}


extension ContentView {
    
    private var userStockData: some View {

        
        HStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ColorConvert().convertColor(hexString: "#222127"), lineWidth: 2)
                    .background(RoundedRectangle(cornerRadius: 10).fill(ColorConvert().convertColor(hexString: "#131319")))
                    .frame(width: width - 40, height: 80)
                
                HStack {
                    Text("Investing")
                        .bold()

                        .font(Font.system(size: 15))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack {
                        Text("$0.00")
                            .bold()

                            .font(Font.system(size: 15))
                            .foregroundColor(Color.white)
                        Text("0 Shares")
                            .bold()

                            .font(Font.system(size: 15))
                            .foregroundColor(Color.white)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 50.0, bottom: 0, trailing: 50.0))
                    
                    //.padding(EdgeInsets(top: 40.0, leading: 30.0, bottom: 0.0, trailing: 0.0))
            }
            

            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .center)
        //.border(Color.white, width: 1)
        
    }
}


extension ContentView {
    
    
    private var customButtons: some View {
        

            
            HStack {
                Spacer()
                Button("Trade Stocks") {
                }
                .font(.system(size: 15, weight: .bold, design: .default))
                .foregroundColor(Color.white)
                .frame(width: width - 70, height: 15)
                .padding()
                .background(

                    RoundedRectangle(cornerRadius: 10)
                        .fill(buttonColor)
                )
                .shadow(color: buttonColor, radius: 20, x: 0.0, y: 0.0)
                Spacer()
            }.frame(maxHeight: .infinity, alignment: .top)
           // .border(Color.yellow, width: 1)

        
        
    }
}

extension ContentView {
    private var textBox: some View {
        VStack {
            
            HStack {
                Text("Apple")
                    .bold()

                    .font(Font.system(size: 15))
                    .foregroundColor(ColorConvert().convertColor(hexString: "#A6A6A6"))
                    
                    .padding(EdgeInsets(top: 40.0, leading: 30.0, bottom: 0.0, trailing: 0.0))

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text(hoveredPrice)
                    .bold()

                    .font(Font.system(size: 35))
                    .foregroundColor(textColor)
                    
                    .padding(EdgeInsets(top: -10.0, leading: 30.0, bottom: 0.0, trailing: 0.0))
                    //.border(Color.blue, width: 4)
                    .onAppear{
                        hoveredPrice = "$171.15"
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text(calculatePlusMinus(hoveredPrice: hoveredPrice, closedPrice: closedPrice))
                    .bold()

                    .font(Font.system(size: 15))
                    .foregroundColor(textColor)
                    .tracking(0.5)
                    .padding(EdgeInsets(top: 0.0, leading: 30.0, bottom: 0.0, trailing: 0.0))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(hoveredDate)
                    .font(Font.system(size: 15))
                    .bold()
                    .foregroundColor(textColor)

                
                    .padding(EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 30.0))
                    .frame(alignment: .trailing)

                
                
            }
            
            
        }
       // .border(Color.red, width: 1)
        

    }
}


extension ContentView {
    private var chartComponent: some View {
        ZStack {
            
            GeometryReader { geometry in


                chartView
                    .frame(height: 400)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged { value in

                                isHidden = true
                                
                                xVal = getClosestValue(to: value.location.x, from: distances)!
                                
                                // gets the price according to the index of the data points (x coordinate)
                                let priceIndex = round(Double(data[distances.firstIndex(of: xVal)!] * 100.0)) / 100.0
                                
                                let dateIndex = String(dates[distances.firstIndex(of: xVal)!])
                                
                                yVal = ((Double(geometry.frame(in: .global).minY)) - 120) + map[xVal]!

                                hoveredPrice = "$" + String(priceIndex)
                                hoveredDate = dateIndex

                            }
                            .onEnded { _ in }
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.linear(duration: 2.0)) { percentage = 1.0 }
                        }
                    }
                    .position(x: (Double(geometry.frame(in: .global).midX)), y: 250)
                    
                
                IndicatorPoint
                    .position(x: CGFloat(xVal), y: yVal)
                    
                    .opacity(isHidden ? 1 : 0)

            }
            
        }
        //.border(Color.blue, width: 1)
        
        

    }
}



private var IndicatorPoint: some View {
    ZStack {
        Circle()
            .fill(.black)
        Circle()
            .stroke(Color.white, style: StrokeStyle(lineWidth: 4))
    }
    .frame(width: 8, height: 8)
    .shadow(color: .black, radius: 6, x: 0, y: 6)
}


public func calculatePlusMinus(hoveredPrice: String, closedPrice: String) -> String {
    //"+ 0.11 (0.3%)"
    //print(hoveredPrice, closedPrice)
    if hoveredPrice.count != 0 && closedPrice.count != 0 {
        let hoveredPriceToDouble = Double(hoveredPrice.components(separatedBy: "$")[1])!
        let closedPriceToDouble = Double(closedPrice.components(separatedBy: "$")[1])!
        let difference = hoveredPriceToDouble - closedPriceToDouble
        var stringBuilder = ""
        let formula = round(((difference / closedPriceToDouble) * 100) * 100) / 100
        if formula < 0 {
            stringBuilder += (String(round(difference * 100) / 100) + " (" + String(formula) + "%)")
        } else {
            stringBuilder += ("+" + String(round(difference * 100) / 100) + " (+" + String(formula) + "%)")
        }
        
        
        print(stringBuilder)
        return stringBuilder
    } else {
        return ""
    }


    
    
    
}

func addToList(data: [Double], maxY: Double, minY: Double, width: CGFloat, height: CGFloat) -> ([Double: Double], [CGFloat]) {
    
    var dictionary: [Double: Double] = [:]
    var list: [CGFloat] = []
    
    
    for index in data.indices {
            
        
        let xPosition = 16 + (((width - 32) / CGFloat(data.count)) * CGFloat(index + 1))
        
        
        let yAxis = maxY - minY
        
        let yPosition = CGFloat((1 - CGFloat((data[index] - minY) / yAxis)) * 300)
        
        
        
        list.append(xPosition)
        dictionary[xPosition] = yPosition
        
        
    }
    return (dictionary, list)
}


func getClosestValue(to pivot: CGFloat, from values: [CGFloat]) -> CGFloat? {
    guard let firstValue = values.first else { return nil }
  
    return values.reduce(firstValue) { partialResult, nextValue in
        let partial = abs(pivot - partialResult)
        let next = abs(pivot - nextValue)
    
        if partial > next {
            return nextValue
        } else {
            return partialResult
        }
    }
}



class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
