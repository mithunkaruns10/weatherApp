//
//  CityListViewController.swift
//  WeatherApp
//
//  Created by Mithun on 09/04/20.
//  Copyright © 2020 Mithun. All rights reserved.
//

import UIKit
import CoreData

class CityListViewController: BaseViewController {
    @IBOutlet weak var cityListTableView: UITableView!
    
    @IBOutlet weak var validationErrorLabel: UILabel!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var addCityView: UIView!
    var weatherModel : WeatherModel!
    var weatherCoreDatamodel = [NSManagedObject]()
    var weatherList          = [WeatherModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityListTableView.delegate   = self
        self.cityListTableView.dataSource = self
        let cityNib                       = UINib.init(nibName: Constants.cityListCell, bundle: nil)
        self.cityListTableView.register(cityNib, forCellReuseIdentifier: Constants.cityListCell)
        self.cityListTableView.tableFooterView = UIView()
        removeCityView()
        getDataFromDisc()
        
        
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        
        if(self.cityNameTextField.text == ""){
            self.showCityView(error: "Field is empty", hasError: true)
        }else{
            self.addCity(cityName: self.cityNameTextField.getText())
        }
    }
    
    @IBAction func cancelbuttonClicked(_ sender: Any) {
        removeCityView()
    }
    
    @IBAction func addCityButtonClicked(_ sender: Any) {
        showCityView(error: "", hasError: false)
    }
    
    private func removeCityView(){
        self.view.endEditing(true)
        self.addCityView.isHidden = true
    }
    private func showCityView(error: String, hasError: Bool = false){
        self.cityNameTextField.becomeFirstResponder()
        self.cityNameTextField.text    = ""
        self.addCityView.isHidden      = false
        self.validationErrorLabel.text = ""
        if(hasError){
            self.validationErrorLabel.text = error
        }
    }
    private func addCity(cityName: String){
        self.showLoader()
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(Constants.API_Key)"
        RestConnection.connectionManger.restConnection(url: url, successBlock: { (success) in
            self.weatherModel = WeatherModel()
            self.weatherModel.initWith(dict: success)
            if(self.weatherModel.cityName != nil){
                self.weatherList.append(self.weatherModel)
                self.storeDataToDisc(model: self.weatherModel)
                DispatchQueue.main.async {
                    self.cityListTableView.reloadData()
                    self.removeCityView()
                    self.hideLoader()
                }
            }else{
                DispatchQueue.main.async {
                    self.showCityView(error: "Invalid city name", hasError: true)
                    self.hideLoader()
                }
            }
            
        }, failureBlock: { (failure) in
            print(failure)
            self.hideLoader()
        })
    }
    private  func storeDataToDisc(model: WeatherModel){
        DispatchQueue.main.async {
            guard let appDelegate    = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let entityWeather        = NSEntityDescription.entity(forEntityName: "Weather", in: managedObjectContext)!
            let weather              = NSManagedObject(entity: entityWeather, insertInto: managedObjectContext)
            weather.setValue(model.cityName, forKey: "cityName")
            weather.setValue(model.temp, forKey: "temp")
            weather.setValue(model.timeZone, forKey: "timeZone")
            do{
                try managedObjectContext.save()
                self.getDataFromDisc()
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    }
    private func getDataFromDisc(){
        self.showLoader()
        guard let appDelegate    = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequestOne      = NSFetchRequest<NSManagedObject>(entityName: "Weather")
        do {
            self.weatherCoreDatamodel = try managedObjectContext.fetch(fetchRequestOne)
            DispatchQueue.main.async {
                self.cityListTableView.reloadData()
                self.hideLoader()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCoreDatamodel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = cityListTableView.dequeueReusableCell(withIdentifier: Constants.cityList) as? CityListTableViewCell else {
            let cell             = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
            
        }
        cell.selectionStyle = .none
        if (weatherCoreDatamodel.count > 0){
            cell.cityNamelLabel.text = weatherCoreDatamodel[indexPath.row].value(forKey: "cityName") as? String
            cell.timeLabel.text      = CommonUtilities.getTimeFromTimeZone(timeZone: weatherCoreDatamodel[indexPath.row].value(forKey: "timeZone")  as? Int ?? 0 )
            cell.tempLabel.text      = CommonUtilities.getCelsiusValueFrom(kelvin: weatherCoreDatamodel[indexPath.row].value(forKey: "temp") as? Double ?? 0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb          = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc    = sb.instantiateViewController(withIdentifier: Constants.detailsVC) as? ViewController else {return}
        vc.cityName     = weatherCoreDatamodel[indexPath.row].value(forKey: "cityName") as? String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
