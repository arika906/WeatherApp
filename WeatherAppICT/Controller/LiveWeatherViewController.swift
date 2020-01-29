//
//  ViewController.swift
//  WeatherAppICT
//
//  Created by Md Zahidul Islam Mazumder on 19/12/19.
//  Copyright © 2019 Md Zahidul Islam Mazumder. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Foundation
class LiveWeatherViewController: UIViewController {
    
    
    @IBOutlet weak var locationName: UILabel!
    
    
    //First Part
    
    @IBOutlet weak var ttTimeDate: UILabel!
    @IBOutlet weak var ttTemp: UILabel!
    @IBOutlet weak var ttTempIcon: UIImageView!
    
    @IBOutlet weak var ttTempIconDes: UILabel!
    @IBOutlet weak var ttTempUp: UILabel!
    @IBOutlet weak var ttTempDown: UILabel!
    
    @IBOutlet weak var ttWindSpeed: UILabel!
    @IBOutlet weak var ttProbability: UILabel!
    
    //Second Part
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    
    
    //Third Part
    
    @IBOutlet weak var windImg: UIImageView!
    @IBOutlet weak var windGustValue: UILabel!
    
    
    @IBOutlet weak var pressureIcon: UIImageView!
    @IBOutlet weak var pressureValue: UILabel!
    
    // 4th Part
    
    @IBOutlet weak var sunrise: UIImageView!
    @IBOutlet weak var sunriseTime: UILabel!
    
    @IBOutlet weak var sunset: UIImageView!
    
    @IBOutlet weak var sunsetTime: UILabel!
    
    
    
    
    //Details
    @IBOutlet weak var dImage: UIImageView!
    
    @IBOutlet weak var detailHumidity: UILabel!
    
    @IBOutlet weak var detailPrecipProbability: UILabel!
    
    @IBOutlet weak var detailDewPoint: UILabel!
    
    @IBOutlet weak var detailPressure: UILabel!
    
    @IBOutlet weak var detailWindSpeed: UILabel!
    
    @IBOutlet weak var detailWindGust: UILabel!
    
    
    @IBOutlet weak var detailWindBearing: UILabel!
    
    @IBOutlet weak var detailCloudCover: UILabel!
    @IBOutlet weak var detailVisibility: UILabel!
    
    @IBOutlet weak var detailOzone: UILabel!
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    //var count = 0
    var hourlyData:[DataForHourly]? = []
    var hourlyCount:Int?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print("loc1111",RequestHandler.shared.placeName)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
        
        // Do any additional setup after loading the view.
        //RequestHandler.shared.getRequest(Url: "https://api.openweathermap.org/data/2.5/weather?lat=51.50998&lon=-0.1337&APPID=c379e22089661592e59459eca3028a1c")
        
        locationManager.delegate = self
        
        if RequestHandler.shared.state == -1 {
            getLocation()
            //locationSearch()
            getLatLonfromIP()
        }
        
        
        
        
        if RequestHandler.shared.state == 0 && RequestHandler.shared.searchRequest == false{
            segment.selectedSegmentIndex = 0
            if let globalData = RequestHandler.shared.dayData {
                updateData(currentData: globalData[0]! , dt: globalData[0]!)
            }
            guard let data = RequestHandler.shared.dayData?[1] else {
            return
            }
            
            guard let currently = RequestHandler.shared.dayData?[1] else {
            return
            }
            self.updateData(currentData: currently, dt: data)
            DispatchQueue.main.async {
                self.hourlyCollectionView.reloadData()
            }

        }
        
        if RequestHandler.shared.state == 1 && RequestHandler.shared.searchRequest == false{
            segment.selectedSegmentIndex = 1
            if let globalData = RequestHandler.shared.dayData {
                updateData(currentData: globalData[1]! , dt: globalData[1]!)
            }
            
            DispatchQueue.main.async {
                self.hourlyCollectionView.reloadData()
            }
        }
        
        if RequestHandler.shared.state == 2 && RequestHandler.shared.searchRequest == false{
            
        }
        
        if RequestHandler.shared.searchRequest {
            
            if let place = RequestHandler.shared.placeName{
                self.locationName.text = place
            }
            
            if let coordinate = RequestHandler.shared.coordinate {
                RequestHandler.shared.searchRequest = false
                
                getWeatherForecast(locValue: coordinate)
            }
            DispatchQueue.main.async {
                self.hourlyCollectionView.reloadData()
            }
        }
        //performSegue(withIdentifier: "days", sender: self)
        
//        hourlyCount = hourlyData?.count
//        hourlyCollectionView.reloadData()
//        print("hhhhhh",hourlyCount)
        
        //print("loc222",RequestHandler.shared.placeName)
        
    }
    
    
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        
        switch segment.selectedSegmentIndex {
        case 0:
            print(segment.selectedSegmentIndex)
            self.navigationItem.title = "Today"
            RequestHandler.shared.state = 1
            if let globalData = RequestHandler.shared.dayData {
                updateData(currentData: globalData[0]! , dt: globalData[0]!)
            }
            
            DispatchQueue.main.async {
                self.hourlyCollectionView.reloadData()
            }
            
        case 1:
            print(segment.selectedSegmentIndex)
            RequestHandler.shared.state = 2
            self.navigationItem.title = "Tommorow"
            
            if let globalData = RequestHandler.shared.dayData {
                updateData(currentData: globalData[1]! , dt: globalData[1]!)
            }
            DispatchQueue.main.async {
                self.hourlyCollectionView.reloadData()
            }
            
        case 2:
            RequestHandler.shared.state = 3
            print(segment.selectedSegmentIndex)
            //            let viewController = DaysForecastViewController()
            //            viewController.modalPresentationStyle = .fullScreen
            //            present(viewController, animated: true, completion: nil)
            //            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //            let newViewController = storyBoard.instantiateViewController(withIdentifier: "7days") as! DaysForecastViewController
            //                    self.present(newViewController, animated: false, completion: nil)
            performSegue(withIdentifier: "days", sender: self)
        default:
            break;
        }
        
    }
    
    
   
    
    
    @IBAction func go(_ sender: Any) {
        performSegue(withIdentifier: "days", sender: self)
    }
    
    
    @IBAction func goToSearch(_ sender: UIButton) {
        print("se3")
        performSegue(withIdentifier: "homeTOsearch", sender: self)
    }
    
    
    @IBAction func getGPS(_ sender: UIButton) {
    }
    
    func  getWeatherForecast(locValue: CLLocationCoordinate2D){
        RequestHandler.shared.getAddressFromLatLon(pdblLatitude: locValue.latitude, withLongitude: locValue.longitude )
        RequestHandler.shared.getRequest(urlExtension: "/forecast/5b56d79fb2d1a41dd81282781fa6bf46/\(Double(locValue.latitude)),\(Double(locValue.longitude))?units=si"){
            data in
            //print("data:", data)
            
            if let data = data{
                print("hghhjhfvhf:",data)
                do {
                    let jsonDecoder = JSONDecoder()
                    
                    let responseModel = try jsonDecoder.decode(RootClass.self, from: data)
                    
                    
                    if let dailyData = responseModel.daily {
                        RequestHandler.shared.dayData = dailyData.data
                    }
                    
                    if let hourlyData = responseModel.hourly {
                        
                        self.hourlyData = hourlyData.data
                        if hourlyData.data.count > 24 {
                            self.hourlyCount = 24
                            
                        }
                        
                        
                        //self.hourlyCollectionView.up
                        print("xyz123123",hourlyData)
                    }
                    
                    print("Appplegjgfyjhfhtdgtffhdrgdfhygdr ",responseModel )
                    
                    guard let data = responseModel.daily?.data[0] else {
                    return
                    }
                    
                    guard let currently = responseModel.daily?.data[0] else {
                    return
                    }
                    
                    
                    
                    
                    self.updateData(currentData: currently, dt: data)
                    
                    
                    if RequestHandler.shared.state == 0 || RequestHandler.shared.state == 1
                    {
                        guard let data = responseModel.daily?.data[RequestHandler.shared.state] else {
                        return
                        }
                        
                        guard let currently = responseModel.daily?.data[RequestHandler.shared.state] else {
                        return
                        }
                        
                        self.updateData(currentData: currently, dt: data)
                        
                    }
                    
                    
                   

                    DispatchQueue.main.async {
                        
                        //self.locationName.text = RequestHandler.shared.placeName
                        self.hourlyCollectionView.reloadData()
                    }
                    print("56456789",responseModel.daily?.data[0]?.temperatureMax ?? "")
                } catch {
                    print(error)
                }
                

            }
            
        }
        
        
        
    }
    
    
    
    
    func updateData(currentData:Data,dt:Data)  {
        DispatchQueue.main.async {
            
            
            
            
          if let time = currentData.time {
                
                let timestamp: NSNumber = time as NSNumber
                print(timestamp)  // 1524654473.108564
                let exactDate = NSDate(timeIntervalSince1970: TimeInterval(truncating: timestamp))
                let dateFormatt = DateFormatter()
                dateFormatt.dateFormat = "EEEE, MMM d, yyyy"
                print(dateFormatt.string(from: exactDate as Date)) //25/04/2018 04:37:53 PM
                
                
                //datePopUp.text = "\(NSDate(timeIntervalSince1970: TimeInterval(daysInfo[indexPath.row]?.time ?? 1579248000)))"
                self.ttTimeDate.text = dateFormatt.string(from: exactDate as Date)
                
            }
            
            
            if let windGust = dt.windGust {
                self.windGustValue.text = String(Int(windGust))
            }
            
            if let pressure = dt.pressure {
                self.pressureValue.text = String(Int(pressure))
            }
            
            print("1")
            if let temp = dt.temperatureMax {
                self.ttTemp.text = String(Int(temp)) + "°C"
            }
            print("2")
            if let wind = dt.windSpeed {
                self.ttWindSpeed.text = "Wind Speed: " + String(wind)
            }
            print("3")
            if let probability = dt.precipProbability {
                self.ttProbability.text = "Precip Probability: "+String(probability)
            }
            
            if let description = dt.icon {
                self.ttTempIconDes.text = description.uppercased()
            }
            
            if let tempUp = dt.temperatureMax {
                self.ttTempUp.text = "↑" + String(Int(tempUp))
            }
            
            if let tempDown = dt.temperatureMin {
                self.ttTempDown.text = "↓" + String(Int(tempDown))
            }
            
            
            
            if let humidity = dt.humidity {
                self.detailHumidity.text = "Humidity: \(Int(humidity))"
            }
            
            if let precipProbability = dt.precipProbability {
                self.detailPrecipProbability.text = "Precip Probability: \(Int(precipProbability))"
            }
            
            if let dewPoint = dt.dewPoint {
                self.detailDewPoint.text = "Dew Point: \(Int(dewPoint))"
            }
            
            if let pressure = dt.pressure {
                self.detailPressure.text = "Pressure: \(Int(pressure))"
            }
            
            if let windSpeed = dt.windSpeed {
                self.detailWindSpeed.text = "Wind Speed: \(Int(windSpeed))"
            }
            
            if let windGust = dt.windGust {
                self.detailWindGust.text = "Wind Gust: \(Int(windGust))"
            }
            
            if let windBearing = dt.windBearing {
                self.detailWindBearing.text = "Wind Bearing: \(Int(windBearing))"
            }
            
            if let cloudCover = dt.cloudCover {
                self.detailCloudCover.text = "Cloud Cover: \(Int(cloudCover))"
            }
            
            if let visibility = dt.visibility {
                self.detailVisibility.text = "Visibility: \(Int(visibility))"
            }
            
            if let ozone = dt.ozone {
                self.detailOzone.text = "Ozone: \(Int(ozone))"
            }
            
            if let sunrise = dt.sunriseTime {
                self.sunriseTime.text = self.createDateTime(timestamp: String(sunrise))
            }
            
            if let sunset = dt.sunsetTime {
                self.sunriseTime.text = self.createDateTime(timestamp: String(sunset))
            }
            
            
            
        }
    }
    
    
    func createDateTime(timestamp: String) -> String {
        var strDate = "undefined"
        
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            //let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Dhaka") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "hh:mm a"
            //dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
        return strDate
    }
    
    
    func getLatLonfromIP() {
        
        RequestHandler.shared.getRequest(baseUrl: nil,urlExtension: "http://ip-api.com/json"){
            data in
            
            if let data = data{
                
                print("hghhjhfvhf:",data)
                do {
                    let jsonDecoder = JSONDecoder()
                    let responseModel = try jsonDecoder.decode(Ip.self, from: data)
                    //print("Appplegjgfyjhfhtdgtffhdrgdfhygdr",responseModel.lat! )
                    
                    //LiveWeatherViewController.self.getWeatherForecast(locValue: CLLocationCoordinate2DMake(responseModel.lat!, responseModel.lon!))
                    self.getWeatherForecast(locValue: CLLocationCoordinate2DMake(responseModel.lat!, responseModel.lon!))
                    
                   
                    
                    
                } catch {
                    print(error)
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print("3524346576")
                    print("",json)
                }
                catch{
                    print("Could not serialize")
                }
            }
            
        }
        
    }
    
    
    func locationSearch(){
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Dhanmondi"
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            
            
            for item in response.mapItems {
                print(item.placemark.coordinate )
            }
        }
        
    }
    
    //    func getCurrentLocationWeather(locValue: CLLocationCoordinate2D){
    //        RequestHandler.shared.getRequest(Url: "https://api.openweathermap.org/data/2.5/weather?lat=\(Double(locValue.latitude))&lon=\(Double(locValue.longitude))&APPID=c379e22089661592e59459eca3028a1c"){
    //            data in
    //
    //            if let data = data{
    //                print(data)
    //                do {
    //                    let jsonDecoder = JSONDecoder()
    //                    let responseModel = try jsonDecoder.decode(Json4Swift_Base.self, from: data)
    //                    print(responseModel )
    //                } catch {
    //                    print(error)
    //                }
    //            }
    //
    //        }
    //
    //
    //
    //
    //    }
    
    
}


extension  LiveWeatherViewController:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        print("cfgxhjjb")
        //getCurrentLocationWeather(locValue: locValue)
        //LiveWeatherViewController.getWeatherForecast(locValue: locValue)
        getWeatherForecast(locValue: locValue)
    }
    
    func getLocation(){
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
        
    }
    
}


extension  LiveWeatherViewController:UICollectionViewDelegate,UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        return self.hourlyCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ttCell", for: indexPath) as! TodayTomorrowCollectionViewCell
        
        //print("568-----",RequestHandler.shared.hourlyData)
        
        //DispatchQueue.main.async {
            
            if let hourlyData = self.hourlyData {
                print("56-----",hourlyData)
                cell.probabilityValue.text = "\( hourlyData[indexPath.row].precipProbability ?? 0)"
                
                cell.temp.text = "\(hourlyData[indexPath.row].temperature ?? 20)"
                
                cell.time.text = self.createDateTime(timestamp: "\(hourlyData[indexPath.row].time ?? 1580138340)")
                
                print("ghtrdsa",hourlyData)
                
            //}
            //self.hourlyCollectionView.reloadData()
        }
        
        
        
        
        return  cell
    }
    
    
    
    
}


