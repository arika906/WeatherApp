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
    var gpsLocUpdate = false
    var searchRequest = false
    var placeName:String?
    var coordinate:CLLocationCoordinate2D?
    var state = -1
    var dayData:[Data?]?
        = []
    var hourlyData:[DataForHourly]? = []
    //private init(){}
    
    
//    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completionClosure: @escaping  (String) -> ())  {
//
//        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
//        //let lat: Double = Double("\(pdblLatitude)")!
//        //21.228124
//        //let lon: Double = Double("\(pdblLongitude)")!
//        //72.833770
//        let ceo: CLGeocoder = CLGeocoder()
//        center.latitude = pdblLatitude
//        center.longitude = pdblLongitude
//
//        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
//
//        var address = ""
//
//        ceo.reverseGeocodeLocation(loc, completionHandler:
//            {(placemarks, error) in
//                if (error != nil)
//                {
//                    print("reverse geodcode fail: \(error!.localizedDescription)")
//                }
//                let pm = placemarks! as [CLPlacemark]
//
//                if pm.count > 0 {
//                    let pm = placemarks![0]
//
//                    //var addressString : String = ""
////                    if pm.subLocality != nil {
////                        addressString = addressString + pm.subLocality! + ", "
////                    }
////                    if pm.thoroughfare != nil {
////                        addressString = addressString + pm.thoroughfare! + ", "
////                    }
//
//                    if let locality = pm.locality {
//                        self.placeName = locality
//                        address = locality
//                        completionClosure(address)
//                    }
//
////                    if pm.locality != nil {
////                        //addressString = addressString + pm.locality! + ", "
////                        address = pm.locality!
////                    }
////                    if pm.country != nil {
////                        addressString = addressString + pm.country! + ", "
////                    }
////                    if pm.postalCode != nil {
////                        addressString = addressString + pm.postalCode! + " "
////                    }
//
//
//                    //address = addressString
//                    //print(addressString)
//              }
//        })
//
////        return address
//
//    }

//    RequestHandler.shared.getAddressFromLatLon(pdblLatitude: 23.8103, withLongitude: 90.4125) { [weak self] (address) in
    //            guard let weakself = self else { return}
    //            if address != "" {
    //                print(address)
    //                DispatchQueue.main.async {
    //                    weakself.locationName.text = address
    //                }
    //            }
    //        }
    
    func getImageName(temp:Int)->String{
        
        switch temp {
            
        case -1000...00:
            return "snow"
        case 1...10:
            return "cloud"
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
    
    func getRequest(baseUrl:String? = "https://api.darksky.net" ,urlExtension:String,completionClosure: @escaping  (Foundation.Data?) -> ()) {
        
        let session = URLSession.shared
        let url = URL(string: (baseUrl ?? "") + urlExtension)!
        
        DispatchQueue.main.async
            {
                
                session.dataTask(with: url) { data, response, error in
                    
                    if let data = data{
                        completionClosure(data)
                    }
                    
                    
                }.resume()
        }
    }
    
}


