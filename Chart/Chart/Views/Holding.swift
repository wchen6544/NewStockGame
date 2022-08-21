//
//  Holding.swift
//  Chart
//
//  Created by Wilson Chen on 8/20/22.
//

import SwiftUI

struct Holding<Content: View>: View {
    

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
