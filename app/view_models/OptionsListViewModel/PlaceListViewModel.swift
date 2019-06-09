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
    lazy var apiRequest = ApiRequest(httpLayer: HTTPLayer())
    
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
            getProvinces(completionHandler)
        case .city(let province_id):
            getCitieOfProvince(id: province_id, completionHandler)
        }
    }
    
    func getProvinces(_ completionHandler:(()->Void)?) {
        apiRequest.getProvinces { [weak self](result) in
            switch(result){
            case .failure(let error):
                // FIXME: Plz Handle me
                print(error)
            case .success(let provinces):
                
                self?.provinces = []
                if self?.hasDefaultOption ?? false {
                    let defaultOption=Province(id: nil, name: LocalizationSystem.getStr(forKey: LanguageKeys.allProvinces))
                    self?.provinces.append(defaultOption)
                }
                
                self?.provinces.append(contentsOf: provinces)
                
                DispatchQueue.main.async {
                    completionHandler?()
                }
            }
        }
    }
    
    func getCitieOfProvince(id: Int, _ completionHandler:(()->Void)?) {
        apiRequest.getCitieOfProvince(id: id) { [weak self](result) in
            switch(result){
            case .failure(let error):
                // FIXME: Plz Handle me
                print(error)
            case .success(let cities):
                
                self?.cities=[]
                if self?.hasDefaultOption ?? false {
                    let defaultOption=City(id: nil, name:LocalizationSystem.getStr(forKey: LanguageKeys.allCities))
                    self?.cities.append(defaultOption)
                }
                
                self?.cities.append(contentsOf: cities)
                
                DispatchQueue.main.async {
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
