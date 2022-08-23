//
//  API.swift
//  Chart
//
//  Created by Wilson Chen on 8/16/22.
//

import Foundation

class API {

    struct ReturnData: Codable {
        var data: [Double]
        
    }
    
    struct Date_Price: Codable {
        var dateTime: String
        var value: String
    }

    struct ChartData: Codable {
        
        var z: Date_Price
        var x: Int
        var y: Double
        
    }

    struct Data: Codable {
        var symbol: String
        var company: String
        var timeAsOf: String
        var isNasdaq100: Bool
        var lastSalePrice: String
        var netChange: String
        var percentageChange: String
        var deltaIndicator: String
        var previousClose: String
        var chart: [ChartData]
    }

    struct FData: Codable {
        var data: Data
    }
    
    
    struct PrimaryData: Codable {
        var lastSalePrice: String
        var netChange: String
        var percentageChange: String
        var deltaIndicator: String
        var volume: String
    }
    
    struct LiveData: Codable {
        var primaryData: PrimaryData
    }
    
    struct WholeLiveData: Codable {
        var data: LiveData
    }

    // MARK: - Indicators
    struct Indicators: Codable {
        let quote: [Quote]
    }
    
    struct Quote: Codable {
        let close: [Double]
        let volume: [Int]

    }
    
    struct Welcome: Codable {
        let chart: Chart
    }

    // MARK: - Chart
    struct Chart: Codable {
        let result: [Result]

    }

    // MARK: - Result
    struct Result: Codable {
        let meta: Meta
        let timestamp: [Int]
        let indicators: Indicators
    }
    
    struct Meta: Codable {
        let currency, symbol, exchangeName, instrumentType: String
        let firstTradeDate, regularMarketTime, gmtoffset: Int
        let timezone, exchangeTimezoneName: String
        let regularMarketPrice, chartPreviousClose, previousClose: Double
        let scale, priceHint: Int
        let dataGranularity, range: String
    }


    func createTT(date: String, price: Double) -> (String, Double) {
        return (date, price)
    }

    /*
    
    public func liveData() -> [(String, Double)] {
        /*
        var company = ""
        var stockName = ""
        var prices:[(String, Double)] = []
        var count = 0
         */
        var info:[(String, Double)] = getData().0

        var liveData = [String]()

        var done = false

        let url = URL(string: "https://api.nasdaq.com/api/quote/AAPL/info?assetclass=stocks")!

        let task: Void = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let classroom = try! JSONDecoder().decode(WholeLiveData.self, from: data)

                //liveData.append(classroom.data.primaryData.lastSalePrice)
                //liveData.append(classroom.data.primaryData.percentageChange)
                //liveData.append(classroom.data.primaryData.netChange)
                
                //info.insert(self.createTT(date: classroom.data.primaryData.lastSalePrice, price: 1.0), at: 0)
                
                var lastPrice: String = classroom.data.primaryData.lastSalePrice.components(separatedBy: "$")[1]
                
                
                info.append(self.createTT(date: classroom.data.primaryData.lastSalePrice, price: Double(lastPrice)!))

                done = true

                
            }catch{ print("errorMsg") }
        }.resume()
        

        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return info
    }
    
     */

    
    public func getDataPointsTesting() -> ([Double], [String], String, String, String) {
        
        var prices:[Double] = []
        var dates:[String] = []
        
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/AAPL?region=US&lang=en-US&includePrePost=false&interval=2m&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=finance")!

        let _: Void = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                
                
                var dateVal = ""
                var priceVal = 0.0
                
                
                let classroom = try! JSONDecoder().decode(Welcome.self, from: data)
                
                for date in classroom.chart.result[0].timestamp {
                    
                    dateVal = String(self.getDates(d: Double(date)))
                    
                    
                    dates.append(dateVal)
                }
                
                for price in classroom.chart.result[0].indicators.quote[0].close {
                    
                    priceVal = round(price * 100) / 100
                    
                    
                    prices.append(priceVal)
                }
                

                dispatchGroup.leave()

                
            }
        }.resume()
        

        dispatchGroup.wait()
        
        return (prices, dates, "", "", "")

        
    }

    
    
    func getDates(d: Double) -> String {
        
        let date = Date(timeIntervalSince1970: d)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        dateFormatter.locale = NSLocale.current
        
        // if want full date yyyy-MM-dd HH:mm:ss a
        dateFormatter.dateFormat = "HH:mm:ss a"
        let strDate = dateFormatter.string(from: date)
        
        let hours = Int(strDate.components(separatedBy: ":")[0])! % 12
        
        let fStrData = strDate.components(separatedBy: ":")
        
        let returnData = String(hours) + ":" + fStrData[1] + ":" + fStrData[2]
        
        return returnData
    }
    
    public func getDataPointsPortfolio(symbol: String) -> ([Double], String) {
        
        var stockName = ""
        
        var prices:[Double] = []
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()

        
        var count = 0
        let url = URL(string: "https://api.nasdaq.com/api/quote/" + symbol + "/chart?assetclass=stocks")!

        let _: Void = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let classroom = try! JSONDecoder().decode(FData.self, from: data)
                stockName = classroom.data.symbol
                for student in classroom.data.chart  {
                    var priceVal = 0.0
                    count += 1
                    
                    if let price = Double(student.z.value) {
                        if count % 20 == 0 {

                            priceVal = price
                            
                            prices.insert(priceVal, at: 0)

                        }
                        
                    } else {
                        print("Not a valid number")
                    }
                }
                dispatchGroup.leave()

                
            }
        }.resume()
        

        dispatchGroup.wait()

        return (prices, stockName)
        
    }

    
}
    

