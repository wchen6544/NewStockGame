# Stock Market App

Allows users to track data from over 8000 different stocks and provides users with real-time data. Features a intuitive dashboard which allows users to track their top performing stocks. Built using custom chart library to reduce CPU usage by over 80% compared to others. Designed using Figma and developed using SwiftUI.
* Average CPU usage : 5%
* Memory Usage: 20-25MB


## Views

<p align="center">
  <img alt="port" src="https://raw.githubusercontent.com/wchen6544/NewStockMarket/main/Screen%20Shot%202022-08-21%20at%201.15.27%20PM.png" width="45%">
&nbsp; &nbsp; &nbsp; &nbsp;
  <img alt="chart" src="https://raw.githubusercontent.com/wchen6544/NewStockMarket/main/Screen%20Shot%202022-08-21%20at%201.15.36%20PM.png" width="45%">
</p>


## Custom Animations


https://user-images.githubusercontent.com/63750347/185803423-ed434db4-c3af-4c3e-a584-828d9439f927.mov



https://user-images.githubusercontent.com/63750347/185803425-6a3c7bac-ffd5-49b0-b371-3fa16ad05583.mov

### Encountered Problems

One of the problems I encountered during this project was waiting for the JSON data to load before drawing the charts in the Portfolio Tab. My first solution involed using ``` RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1)) ```. This solution works if you are loading/rendered one view, but doesn't work for multiple. After a while researching I came across DispatchGroup. First you initalize a group ``` 
let dispatchGroup = DispatchGroup() ```. Then you enter the group and when the data is loaded you can leave. After leaving include a dispatchGroup.wait() command until your return block
