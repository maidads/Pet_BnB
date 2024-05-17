//
//  CreateHouseViewModel.swift
//  Pet_BnB
//
//  Created by Kristian Thun on 2024-05-15.
//

import Foundation
import SwiftUI
import PhotosUI

class CreateHouseViewModel: ObservableObject{
    @Published var title = ""
    @Published var description = ""
    @Published var imageURL: String?
    @Published var beds = ""
    @Published var size = ""
    @Published var streetName = ""
    @Published var streetNR = ""
    @Published var city = ""
    var house: House? = nil
    let firebaseHelper = FirebaseHelper()

    @Published var image: UIImage?

    @Published var imageSelection: PhotosPickerItem? = nil {
          didSet {
              loadImageData()
          }
      }
    
    init(house: House?){
        if let house = house{
            self.house = house
            self.title = house.title
            description = house.description
            imageURL = house.imageURL
            if let city = house.city,
               let beds = house.beds,
               let size = house.size,
               let streetNR = house.streetNR,
               let streetName = house.streetName,
               let imageURL = house.imageURL
            {
                self.city = city
                self.beds = "\(beds)"
                self.size = "\(size)"
                self.streetNR = "\(streetNR)"
                self.streetName = streetName
                firebaseHelper.downloadImage(from: imageURL){ image in
                    self.image = image
                }
                
            }
        }
      
    }
    
    func saveHouse() -> Bool{
        if checkAllInfoSet(){
            
            if let image = image,
               let bedsInt = Int(beds),
               let sizeInt = Int(size),
               let streetNRInt = Int(streetNR)
            {
                if house == nil{
                    // Create a new House
                    firebaseHelper.saveHouse(uiImage: image, title: title, description: description, beds: bedsInt, size: sizeInt, StreetName: streetName, streetNr: streetNRInt, city: city)
                    // Only returns true if the house is created for now not if is saved properly
                    
                } else {
                    // We update a house
                    let valuesChanged = checkIfValuesChanged()
                    
                    if let house = house {
                        if imageSelection != nil{
                            print("Image changed upload new Image!!!!!!")
                            firebaseHelper.uploadImage(uiImage: image){ urlString in
                                if let id = house.id{
                                    let changedHouse = House(title: self.title, description: self.description, imageURL: urlString, beds: bedsInt, size: sizeInt, streetName: self.streetName, streetNR: streetNRInt, city: self.city)
                                    self.firebaseHelper.updateHouse(houseID: id, house: changedHouse, with: valuesChanged)
                                }
                            }
                            
                        } else{
                            if let id = house.id{
                            let changedHouse = House(title: title, description: description, beds: bedsInt, size: sizeInt, streetName: streetName, streetNR: streetNRInt, city: city)
                                firebaseHelper.updateHouse(houseID: id, house: changedHouse, with: valuesChanged)
                                
                            }
                        }
                    }
                }
                
            }
        }
        return false
    }

    
    func checkIfValuesChanged() -> [String: Any] {
        var valuesChanged: [String: Any] = [:]
        if let house = house{
            if title != house.title {
                valuesChanged["title"] = title
            }
            if description != house.description{
                valuesChanged["description"] = description
            }
//            if beds != house.beds{
//                valuesChanged["beds"] = beds
         //   }
            
        }
        return valuesChanged
    }
    
    func checkAllInfoSet() -> Bool{
        if !title.isEmpty && !description.isEmpty && image != nil && !beds.isEmpty && !size.isEmpty && !streetName.isEmpty && !streetNR.isEmpty && !city.isEmpty {
            return true
        }
        return  false
    }
    
    func loadImageData() {
        Task {
            do {
                guard let selectedPhoto = imageSelection else {
                    print("No photo selected")
                    return
                }
                let imageData = try await selectedPhoto.loadTransferable(type: Data.self)
                DispatchQueue.main.async {
                  //  self.selectedPhotoData = imageData
                    if let imageData = imageData{
                        self.image = UIImage(data: imageData)
                   
                    }
                    
                }
            } catch {
                print("Error loading image data: \(error)")
            }
        }
    }
}
