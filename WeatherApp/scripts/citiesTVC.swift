//
//  citiesTVC.swift
//  WeatherApp
//
//  Created by   Андрей on 25.11.2020.
//

import UIKit
import Alamofire
import SwiftyJSON


class citiesTVC: UITableViewController {
    
    @IBOutlet weak var cityTableView: UITableView!
    
    var cityName = ""
    
    struct Cities {
        var cityName = ""
        var cityTemp = 0.0
    }
    
    var cityTempArray: [Cities] = []
    
    func currentWeather(city: String){
        var APIkey = "5e0c557a8564411e8c883533202511"
        let url = "http://api.weatherapi.com/v1/current.json?key=5e0c557a8564411e8c883533202511&q=\(city)"
        
        AF.request(url, method: .get).validate().responseJSON {response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let name = json["location"]["name"].stringValue
                print(name)
                let temp = json["current"]["temp_c"].doubleValue
                print(temp)
                self.cityTempArray.append(Cities(cityName: name, cityTemp: temp))
                self.cityTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    @IBAction func addCityAction(_ sender: Any) {
        let alert = UIAlertController(title: "Add", message: "Input city name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Moscow"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let name = alert.textFields![0].text
            self.currentWeather(city: name!)
            
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cityTableView.delegate = self
        cityTableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cityTempArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! citiesNameCell

        cell.cityName.text = cityTempArray[indexPath.row].cityName
        cell.cityTemp.text = String(cityTempArray[indexPath.row].cityTemp)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityName = cityTempArray[indexPath.row].cityName
        performSegue(withIdentifier: "goDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? detailVCViewController {
            vc.cityName = cityName
        }
    }
}
