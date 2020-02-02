//
//  SearchViewController.swift
//  WeatherAppICT
//
//  Created by Md Zahidul Islam Mazumder on 28/1/20.
//  Copyright © 2020 Md Zahidul Islam Mazumder. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchLocation: UITextField!
    
    @IBOutlet weak var tblSearchResult: UITableView!
    
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchCompleter.delegate = self
        searchLocation.becomeFirstResponder()
        
    }
    

    @IBAction func searching(_ sender: UITextField) {
        
        self.tblSearchResult.reloadData()
        
        //searchCompleter.filterType = .locationsOnly
        searchCompleter.queryFragment = sender.text ?? ""
        
        
    }
    
    @IBAction func Cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return searchResults.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tblSearchResult.deselectRow(at: indexPath, animated: true)
            let completion = searchResults[indexPath.row]
            print(indexPath.row)
            let searchRequest = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                print(response?.mapItems[0].name ?? "")
                if let coordinate = response?.mapItems[0].placemark.coordinate {
                    RequestHandler.shared.coordinate = coordinate
                    
                    print("3343565gfgfb",String(describing: coordinate))
                }
                
                if let place = response?.mapItems[0].placemark.name {
                    RequestHandler.shared.placeName = place
                    RequestHandler.shared.searchRequest = true
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
                
                
                
            }
            self.tblSearchResult.reloadData()
        
        //dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let searchResult = searchResults[indexPath.row]
        let strTitle = searchResult.title
        let strSubTitle = searchResult.subtitle

        cell.textLabel?.text = strTitle
        cell.detailTextLabel?.text = strSubTitle

        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        tableView.separatorColor = UIColor.lightGray

        return cell
        
    }
    
    
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        print(searchResults)
        self.tblSearchResult.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print("Error : \(error.localizedDescription)")
    }
}

extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
