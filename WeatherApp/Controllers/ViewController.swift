//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mithun on 08/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    @IBOutlet weak var weatherTableViewHt: NSLayoutConstraint!
    
    @IBOutlet weak var weatherTodayDescription: UILabel!
    @IBOutlet weak var weatherDetailsTableView: UITableView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    var weatherModel = WeatherModel()
    var cityName: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherTableView.delegate          = self
        self.weatherDetailsTableView.delegate   = self
        self.weatherTableView.dataSource        = self
        self.weatherDetailsTableView.dataSource = self
        self.weatherCollectionView.dataSource   = self
        getWeatherdetails(city: self.cityName?.getText() ?? "")
        
        let weatherNib        = UINib.init(nibName: Constants.weatherCell, bundle: nil)
        let weatherDetailsNib = UINib.init(nibName: Constants.weatherDetailsCell, bundle: nil)
        let weatherCollNib    = UINib.init(nibName: Constants.weatherCollecCell, bundle: nil)
        
        self.weatherTableView.register(weatherNib, forCellReuseIdentifier: Constants.weatherCell)
        self.weatherDetailsTableView.register(weatherDetailsNib, forCellReuseIdentifier: Constants.weatherDetailsCell)
        self.weatherCollectionView.register(weatherCollNib, forCellWithReuseIdentifier: Constants.weatherCollecCell)
        self.weatherTodayDescription.text = "Today: Today: Mostly sunny currently. The  high will be  35º. Clear tonight with a low of 19º"
        self.cityNameLabel.text           = self.cityName ?? ""
        self.weatherDescription.text      = "Mostly Sunny"
        self.weatherDetailsTableView.tableFooterView = UIView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.weatherTableViewHt.constant = self.weatherTableView.contentSize.height
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    private func getWeatherdetails(city: String){
        self.showLoader()
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Constants.API_Key)"
        RestConnection.connectionManger.restConnection(url: url, successBlock: { (success) in
            self.weatherModel = WeatherModel()
            self.weatherModel.initWith(dict: success)
            DispatchQueue.main.async {
                self.weatherDetailsTableView.reloadData()
                self.hideLoader()
            }
            
        }, failureBlock: { (failure) in
            print(failure)
            self.hideLoader()
        })
    }
    


}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == weatherTableView){
            return 6
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == weatherTableView){
            guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: Constants.weatherCell, for: indexPath) as? weatherTableViewCell else {return UITableViewCell()}
            switch indexPath.row {
            case 0:
                cell.dayNameLabel.text  = "Tuesday"
                cell.weatherImage.image = #imageLiteral(resourceName: "cloud")
                cell.tempMax.text       = "29"
                cell.tempMin.text       = "25"
            case 1:
                cell.dayNameLabel.text  = "Wednesday"
                cell.weatherImage.image = #imageLiteral(resourceName: "sun")
                cell.tempMax.text       = "35"
                cell.tempMin.text       = "30"
            case 2:
                cell.dayNameLabel.text  = "Thursday"
                cell.weatherImage.image = #imageLiteral(resourceName: "cloud")
                cell.tempMax.text       = "32"
                cell.tempMin.text       = "27"
            case 3:
                cell.dayNameLabel.text  = "Friday"
                cell.weatherImage.image = #imageLiteral(resourceName: "sun")
                cell.tempMax.text       = "33"
                cell.tempMin.text       = "29"
            case 4:
                cell.dayNameLabel.text  = "Saturday"
                cell.weatherImage.image = #imageLiteral(resourceName: "sun")
                cell.tempMax.text       = "36"
                cell.tempMin.text       = "33"
            case 5:
                cell.dayNameLabel.text  = "Sunday"
                cell.weatherImage.image = #imageLiteral(resourceName: "sun")
                cell.tempMax.text       = "34"
                cell.tempMin.text       = "28"
            default:
                cell.dayNameLabel.text  = ""
                cell.weatherImage.image = #imageLiteral(resourceName: "cloud")
                cell.tempMax.text       = ""
                cell.tempMin.text       = ""
            }
            cell.selectionStyle         = .none
            return cell
        }else{
            guard let cell = weatherDetailsTableView.dequeueReusableCell(withIdentifier: Constants.weatherDetailsCell, for: indexPath) as? weatherDetailsTableViewCell else {return UITableViewCell()}
            switch indexPath.row {
            case 0:
                cell.headingOne.text = "SUNRISE"
                cell.headingTwo.text = "SUNSET"
                cell.valueOne.text   = CommonUtilities.getSunTimings(time: weatherModel.sunrisetime ?? 0)
                cell.valueTwo.text   = CommonUtilities.getSunTimings(time: weatherModel.sunSetTime ?? 0)
            case 1:
                cell.headingOne.text = "CHANCE OF RAIN"
                cell.headingTwo.text = "HUMIDITY"
                cell.valueOne.text   = "0%"
                cell.valueTwo.text   = "\(weatherModel.humidity ?? 0)%"
            case 2:
                cell.headingOne.text = "WIND"
                cell.headingTwo.text = "FEELS LIKE"
                cell.valueOne.text   = "SW \(weatherModel.windSpeed ?? 0) kph"
                cell.valueTwo.text   = CommonUtilities.getCelsiusValueFrom(kelvin: weatherModel.feels_like ?? 0)
            case 3:
                cell.headingOne.text = "PRECIPITATION"
                cell.headingTwo.text = "PRESSURE"
                cell.valueOne.text   = "0 cm"
                cell.valueTwo.text   = "\(weatherModel.pressure ?? 0) hPa"
            case 4:
                cell.headingOne.text = "VISIBILITY"
                cell.headingTwo.text = "UV INDEX"
                cell.valueOne.text   = "\(weatherModel.visibility ?? 0) km"
                cell.valueTwo.text   = "11"
                
            default:
                cell.headingOne.text = ""
                cell.headingTwo.text = ""
                cell.valueOne.text   = ""
                cell.valueTwo.text   = ""
            }
            cell.selectionStyle      = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == weatherTableView){
            return 35
        }else{
            return UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    
}
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.weatherCollecCell, for: indexPath) as? weatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch indexPath.row {
        case 0:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "NOW"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 1:
            cell.tempLabel.text   = "34º"
            cell.timelabel.text   = "11AM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 2:
            cell.tempLabel.text   = "34º"
            cell.timelabel.text   = "12AM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 3:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "1PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 4:
            cell.tempLabel.text   = "35º"
            cell.timelabel.text   = "2PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 5:
            cell.tempLabel.text   = "33º"
            cell.timelabel.text   = "3AM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 6:
            cell.tempLabel.text   = "32º"
            cell.timelabel.text   = "4PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 7:
            cell.tempLabel.text   = "30º"
            cell.timelabel.text   = "5PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 8:
            cell.tempLabel.text   = "29º"
            cell.timelabel.text   = "6PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        case 9:
            cell.tempLabel.text   = "29º"
            cell.timelabel.text   = "7PM"
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        default:
            cell.tempLabel.text   = ""
            cell.timelabel.text   = ""
            cell.weatherImg.image = #imageLiteral(resourceName: "sun")
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
   
}
