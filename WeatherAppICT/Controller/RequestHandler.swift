//
//  RequestHandler.swift
//  WeatherAppICT
//
//  Created by Md Zahidul Islam Mazumder on 19/12/19.
//  Copyright © 2019 Md Zahidul Islam Mazumder. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let baseUrl = "https://api.darksky.net"
class RequestHandler{
    
    static let shared = RequestHandler()
    var searchRequest = false
    var placeName:String?
    var coordinate:CLLocationCoordinate2D?
    var state = -1
    var dayData:[Data?]?
        = []
    var hourlyData:[DataForHourly]? = []
    //private init(){}
    
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        //let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        //let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude

        var loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        //var address = ""
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print("c",pm.country)
                    print("loc",pm.locality)
                    print("su",pm.subLocality)
                    print("th",pm.thoroughfare)
                    print("po",pm.postalCode)
                    print("st",pm.subThoroughfare)
                    //var addressString : String = ""
//                    if pm.subLocality != nil {
//                        addressString = addressString + pm.subLocality! + ", "
//                    }
//                    if pm.thoroughfare != nil {
//                        addressString = addressString + pm.thoroughfare! + ", "
//                    }
                    
                    if let locality = pm.locality{
                        self.placeName = locality
                    }
                    
//                    if pm.locality != nil {
//                        //addressString = addressString + pm.locality! + ", "
//                        address = pm.locality!
//                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }


                    //address = addressString
                    //print(addressString)
              }
        })

        
    }

    
    
    func getImageName(temp:Int)->String{
        
        switch temp {
            
        case -1000...00:
            return "snow"
        case 1...10:
            return "cloud.fog"
        case 11...14:
            return "PartlyCloud"
        case 15...18:
            return "MostlyCloud"
        case 19...30:
            return "Clear"
        case 31...45:
            return "Sunny"
        default:
            return "Rainy"
        }
        
    }
    
    
    func getResponseModel(responseModel:Any)->Any{
        
        
        return responseModel
    }
    //    func getRequestWithHeader(urlExtension:String){
    //
    //        let headers = [
    //            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
    //            "x-rapidapi-key": "6a2b9ff5a9msh9dfb8ca364e93dep1ac43fjsn7d2d459bb92c"
    //        ]
    //
    //       // https://community-open-weather-map.p.rapidapi.com/forecast/daily?lat=35&lon=139&cnt=10&units=metric%20or%20imperial
    //
    //        let request = NSMutableURLRequest(url: NSURL(string: "https://community-open-weather-map.p.rapidapi.com" + urlExtension)! as URL,
    //            cachePolicy: .useProtocolCachePolicy,
    //        timeoutInterval: 10.0)
    //
    //        request.httpMethod = "GET"
    //        request.allHTTPHeaderFields = headers
    //
    //        let session = URLSession.shared
    //        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    //
    //            if let responseData = data
    //            {
    //                do{
    //                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
    //                    print(json)
    //                }catch{
    //                    print("Could not serialize")
    //                }
    //            }
    //
    //            if (error != nil) {
    //                print(error)
    //            } else {
    //                let httpResponse = response as? HTTPURLResponse
    //                print(httpResponse!)
    //            }
    //        })
    //
    //        dataTask.resume()
    //
    //    }
    //
    func getRequest(baseUrl:String? = "https://api.darksky.net" ,urlExtension:String,completionClosure: @escaping  (Foundation.Data?) -> ()) {
        
        let session = URLSession.shared
        let url = URL(string: (baseUrl ?? "") + urlExtension)!
        
        DispatchQueue.main.async
            {
                
                session.dataTask(with: url) { data, response, error in
                    
                    if let data = data{
                        completionClosure(data)
                    }
                    
                    /*
                     do{
                     let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                     print("3524346576")
                     print("",json)
                     }
                     catch{
                     print("Could not serialize")
                     }
                     */
                }.resume()
        }
    }
    
}


