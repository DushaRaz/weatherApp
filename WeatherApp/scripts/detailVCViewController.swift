//
//  detailVCViewController.swift
//  WeatherApp
//
//  Created by   Андрей on 25.11.2020.
//

import UIKit
import Alamofire
import SwiftyJSON

class detailVCViewController: UIViewController {
    
    var cityName = ""
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeather(city: cityName)
        print("123")
        print(cityName)
        // Do any additional setup after loading the view.
    }
    
    func currentWeather(city: String){
        let url = "http://api.weatherapi.com/v1/current.json?key=5e0c557a8564411e8c883533202511&q=\(city)"
        print(url)
        AF.request(url, method: .get).validate().responseJSON {response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let name = json["location"]["name"].stringValue
                let temp = json["current"]["temp_c"].doubleValue
                let country = json["location"]["country"].stringValue
                let weathreURLString = "http:\(json["location"][0]["icon"].stringValue)"
                
                self.cityLabel.text = name
                self.tempLabel.text = String(temp)
                
                let weatherURL = URL(string: weathreURLString)
                if let data = try? Data(contentsOf: weatherURL!){
                    self.imageWeather.image = UIImage(data: data)
                }
                print(value)
            case .failure(let error):
                print(error)
            }
        }
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
