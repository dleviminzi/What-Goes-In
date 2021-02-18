//
//  InputViewModel.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/9/21.
//

import CodeScanner
import Foundation
import SwiftUI
import CoreData

extension FoodDrinkInputView {
    class ViewModel: ObservableObject {
        @Published var isShowingScanner = false
        @Published var item_name: String = ""
        let persistenceController = PersistenceController.shared
        var moc: NSManagedObjectContext

        init() {
            /* managed object context for persistent storage */
            moc = persistenceController.container.viewContext
        }
    
        
        // MARK: - Barcode scan input
        
        /* Closes scanner view and instructs model to handle result of scan */
        func handleScan(result: Result<String, CodeScannerView.ScanError>) {
            isShowingScanner = false
            
            switch result {
            case .success(let code):
                /* place barcode number into the API endpoint url and make request*/
                let formattedURL: String = "https://world.openfoodfacts.org/api/v0/product/\(code).json"
                oFFRequest(OFFEndPoint: formattedURL)
    
            case .failure(let error):
                // TODO: HANDLE ERRORS IN MORE ROBUST WAY -.-
                print(error)
            }
        }
        
        
        /* Sends request to open food facts to retrieve food details */
        func oFFRequest(OFFEndPoint: String) {
            let decoder = JSONDecoder()
            
            if let url = URL(string: OFFEndPoint) {
                if let data = try? Data(contentsOf: url) {
                    if let apiRes = try? decoder.decode(OFFFood.self, from: data) {
                        /* TODO: [] srsly fix response to potential, inevitable failure */
                        
                        
                        let food = Food(context: moc)
                        food.id = UUID()
                        food.name = apiRes.product.product_name
                        food.date = Date()
                        
                        do {
                            try self.moc.save()
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            }
        }
        
        // MARK: - Text input
        func handleTextInput(item: String) {
            /* replacing spaces with %20 for edamam end point */
            let ingredient = item.replacingOccurrences(of: " ", with: "%20")
            let edamamEndPoint: String = "https://api.edamam.com/api/food-database/v2/parser?ingr=\(ingredient)&app_id=5adb2f74&app_key=6291d1950f331d180fdbaff764e556ad"

            let decoder = JSONDecoder()
            
            if let url = URL(string: edamamEndPoint) {
                if let data = try? Data(contentsOf: url) {
                    if let apiRes = try? decoder.decode(EdamamFood.self, from: data) {
                        print(apiRes.parsed[0]["food"]?.label ?? "shit")
                    }
                }
            }
        }
    }
}
