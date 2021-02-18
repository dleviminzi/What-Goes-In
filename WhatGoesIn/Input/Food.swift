//
//  Food.swift
//  WhatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/18/21.
//

import Foundation

// TODO: [x] define basic edamam format
//       [x] define basic OFF format
//       [] flesh out keys per API specs
//       [] mark most keys as optional
//       [] map names to global names

// MARK: - JSON structure for edamam ingredient API return
struct NutrientsEDA: Codable {
    var energyKCAL: Float
    var protein: Float
    var fat: Float
    var carbs: Float
    var fiber: Float
    
    enum CodingKeys: String, CodingKey {
        case energyKCAL = "ENERC_KCAL"
        case protein = "PROCNT"
        case fat = "FAT"
        case carbs = "CHOCDF"
        case fiber = "FIBTG"
    }
}

struct FoodDetails: Codable {
    var label: String           /* interpreted name */
    var nutrients: NutrientsEDA
}


struct EdamamFood: Codable {
    var text: String            /* input name */
    var parsed: [[String: FoodDetails]]
}


// MARK: - JSON structure for open food facts API return

struct NutrientsOFF: Codable {
    var energyKCAL: Float
    var protein: Float
    var fat: Float
    var carbs: Float?
    var fiber: Float?
    
    enum CodingKeys: String, CodingKey {
        case energyKCAL = "energy-kcal"
        case protein = "proteins"
        case fat = "fat"
        case carbs = "carbohydrates"
        case fiber = "fiber"
    }
    
}

struct ProductDetails: Codable {
    var nutrition_data_per: String      /* grams on item */
    var ingredients_text_en: String     /* list of ingredients */
    var product_name: String
    var nutriments: NutrientsOFF
}

struct OFFFood: Codable {
    var product: ProductDetails
}
