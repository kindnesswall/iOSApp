//
//  PlaceListViewModel.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class PlaceListViewModel: NSObject, OptionsListViewModelProtocol {

    let titleName:String
    let hasDefaultOption:Bool
    let showCities:Bool
    
    enum PlaceType {
        case province
        case city(province_id:Int)
    }
    let placeType:PlaceType
    
    var provinces=[Province]()
    var cities=[City]()
    
    func getElementsCount()->Int{
        switch placeType {
        case .province:
            return self.provinces.count
        case .city:
            return self.cities.count
        }
    }
    
    func registerCell(tableView:UITableView){
        tableView.register(type: GenericOptionsTableViewCell.self)
    }
    
    func dequeueReusableCell(tableView:UITableView,indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericOptionsTableViewCell.identifier, for: indexPath) as! GenericOptionsTableViewCell
        switch placeType {
        case .province:
            cell.setValue(name: provinces[indexPath.row].name)
        case .city:
            cell.setValue(name: cities[indexPath.row].name)
        }
        return cell
    }
    
    init(placeType:PlaceType,showCities:Bool,hasDefaultOption:Bool) {
        
        self.titleName = LocalizationSystem.getStr(forKey: LanguageKeys.placeOfTheGift)
        self.placeType=placeType
        self.hasDefaultOption=hasDefaultOption
        self.showCities=showCities
        
        super.init()
        
    }
    
    func fetchElements(completionHandler:(()->Void)?) {
        switch placeType {
        case .province:
            fetchProvinces(completionHandler: completionHandler)
        case .city(let province_id):
            fetchCities(province_id: province_id, completionHandler: completionHandler)
        }
    }
    
    func fetchProvinces(completionHandler:(()->Void)?){
        let input : APIEmptyInput? = nil
        APICall.request(url: URIs().province, httpMethod: .GET, input: input) { [weak self] (data,response,error) in
            DispatchQueue.main.async {
                if let jsonPlaces=ApiUtility.convert(data: data, to: [Province].self) {
                    
                    self?.provinces=[]
                    if self?.hasDefaultOption ?? false {
                        let defaultOption=Province(id: 0, name: LocalizationSystem.getStr(forKey: LanguageKeys.allProvinces))
                        self?.provinces.append(defaultOption)
                    }
                    
                    self?.provinces.append(contentsOf: jsonPlaces)
                    
                    completionHandler?()
                }
            }
        }
    }
    
    func fetchCities(province_id:Int,completionHandler:(()->Void)?){
        let input : APIEmptyInput? = nil
        let url = "\(URIs().city)/\(province_id)"
        APICall.request(url: url, httpMethod: .GET, input: input) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let jsonPlaces=ApiUtility.convert(data: data, to: [City].self) {
                    
                    self?.cities=[]
                    if self?.hasDefaultOption ?? false {
                        let defaultOption=City(id: 0, name:LocalizationSystem.getStr(forKey: LanguageKeys.allCities))
                        self?.cities.append(defaultOption)
                    }
                    
                    self?.cities.append(contentsOf: jsonPlaces)
                    
                    completionHandler?()
                }
            }
        }
    }
    
    
    func returnCellData(indexPath:IndexPath)->(Int?,String?) {
        switch placeType {
        case .province:
            let province = provinces[indexPath.row]
            return (province.id,province.name)
        case .city:
            let city = cities[indexPath.row]
            return (city.id,city.name)
        }
        
    }
    
    func getNestedViewModel(indexPath:IndexPath)->OptionsListViewModelProtocol? {
        switch placeType {
        case .province:
            guard showCities else {
                return nil
            }
            guard let province_id = provinces[indexPath.row].id else {
                return nil
            }
            let viewModel = PlaceListViewModel(placeType: .city(province_id: province_id),showCities: self.showCities, hasDefaultOption: self.hasDefaultOption)
            return viewModel
        case .city:
            return nil
            
        }
    }
    
    
}
