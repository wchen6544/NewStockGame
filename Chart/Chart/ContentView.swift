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
    
    let company: String
    let symbol: String
    
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
        minY = data.min() ?? 0
        maxY = data.max() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.green : Color.red

        
        width = bounds.size.width
        height = bounds.size.height
        
        let tmp = addToList(data: data, maxY: maxY, minY: minY, width: width, height: height)
        distances = tmp.1
        map = tmp.0
        //let result = apiCalls.getData()
        
    }



    @State private var xV: Double = 0.0
    @State private var yV: Double = 0.0
    
    
    @State private var xVal: CGFloat = 0
    @State private var yVal: Double = 0.0
    
    @State var hoveredPrice:String = ""
    @State var hoveredDate:String = ""
    
    @State var isHidden:Bool = false
    
    @State var pointColor: UIColor = UIColor.clear
    
    var body: some View {
        VStack {
            
            
                ZStack {
                    
                    GeometryReader { geometry in

                    
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(color: Color(white: 0.9, opacity: 1), radius: 8)
                            .frame(height: 300)
                            //.border(Color.blue, width: 4)
                        
                        
                        
                        chartView
                            .frame(height: 200)
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                    .onChanged { value in

                                        isHidden = true
                                        
                                        xVal = getClosestValue(to: value.location.x, from: distances)!
                                        
                                        // gets the price according to the index of the data points (x coordinate)
                                        let priceIndex = round(Double(data[distances.firstIndex(of: xVal)!] * 100.0)) / 100.0
                                        
                                        let dateIndex = String(dates[distances.firstIndex(of: xVal)!])
                                        
                                        
                                        var top = ((Double(geometry.frame(in: .global).minY)))
                                        

                                        yVal = top + map[xVal]!

                                        
                                        // 1.703056768558952 79.11392405063371
                                        
                                        hoveredPrice = "$" + String(priceIndex)
                                        hoveredDate = dateIndex

                                    }
                                    .onEnded { _ in }
                            )
                            //.border(Color.purple, width: 4)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.linear(duration: 2.0)) { percentage = 1.0 }
                                }
                            }
                            .position(x: (Double(geometry.frame(in: .global).midX)), y: 150)
                            
                            
                        
                        
                        IndicatorPoint
                            .position(x: CGFloat(xVal), y: yVal)
                            
                            .opacity(isHidden ? 1 : 0)

                        
                            
                    }
                }
            
            

            
            VStack (alignment: .leading) {
                Text(hoveredPrice)
                Text(hoveredDate)
                Text(company)
                Text(symbol)
                
            }
            
            }
            
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
                    
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    
                    // height: 200, width: 390
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    } else {
                        path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    }
                }
                
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)

        }
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


func addToList(data: [Double], maxY: Double, minY: Double, width: CGFloat, height: CGFloat) -> ([Double: Double], [CGFloat]) {
    
    var dictionary: [Double: Double] = [:]
    var list: [CGFloat] = []
    
    
    for index in data.indices {
            
        print(width, height)
        
        let xPosition = width / CGFloat(data.count) * CGFloat(index + 1)
        
        
        let yAxis = maxY - minY
        
        let yPosition = CGFloat((1 - CGFloat((data[index] - minY) / yAxis)) * 200)
        
        
        list.append(xPosition)
        dictionary[xPosition] = yPosition
        
        
    }
    //return dictionary
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


