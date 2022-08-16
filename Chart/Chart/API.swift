//
//  API.swift
//  Chart
//
//  Created by Wilson Chen on 8/16/22.
//

import Foundation

class API {

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


    func createTT(date: String, price: Double) -> (String, Double) {
        return (date, price)
    }

    
    public func getData() -> ([(String, Double)], String, String) {
        
        var company = ""
        var stockName = ""
        var prices:[(String, Double)] = []
        var done = false
        var count = 0
        let url = URL(string: "https://api.nasdaq.com/api/quote/AAPL/chart?assetclass=stocks")!

        let task: Void = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let classroom = try! JSONDecoder().decode(FData.self, from: data)
                company = classroom.data.company
                stockName = classroom.data.symbol
                for student in classroom.data.chart  {
                    var priceDate = ""
                    var priceVal = 0.0
                    count += 1
                    
                    if let price = Double(student.z.value) {
                        if count % 10 == 0 {
                                  //5
                            //prices.insert(price, at: 0)
                            priceVal = price
                            
                            let date = String(student.z.dateTime)

                            priceDate = date
                            
                            prices.insert(self.createTT(date: priceDate, price: priceVal), at: 0)

                        }
                        

                        

                    } else {
                        print("Not a valid number")
                    }
                    
                    
                }
                done = true

                
            }catch{ print("errorMsg") }
        }.resume()
        

        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return (prices, company, stockName)
        
    }
    
    
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
    
    
    public func getDataPoints() -> ([Double], [String], String, String) {
        
        var company = ""
        var stockName = ""
        
        var prices:[Double] = []
        var dates:[String] = []
        
        var done = false
        var count = 0
        let url = URL(string: "https://api.nasdaq.com/api/quote/AAPL/chart?assetclass=stocks")!

        let _: Void = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            do{
                let classroom = try! JSONDecoder().decode(FData.self, from: data)
                company = classroom.data.company
                stockName = classroom.data.symbol
                for student in classroom.data.chart  {
                    var priceDate = ""
                    var priceVal = 0.0
                    count += 1
                    
                    if let price = Double(student.z.value) {
                        if count % 5 == 0 {
                                  //5
                            //prices.insert(price, at: 0)
                            priceVal = price
                            
                            let date = String(student.z.dateTime)

                            priceDate = date
                            
                            prices.insert(priceVal, at: 0)
                            dates.insert(priceDate, at : 0)

                        }
                        

                        

                    } else {
                        print("Not a valid number")
                    }
                    
                    
                }
                done = true

                
            }catch{ print("errorMsg") }
        }.resume()
        

        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        } while !done
        
        return (prices, dates, company, stockName)
        
    }

}
