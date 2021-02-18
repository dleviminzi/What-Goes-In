//
//  InputV.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/5/21.
//

/* There has got to be a better way to organize this view */

import CoreData
import CodeScanner
import SwiftUI

struct InputView: View {
    /* trigger for barcode scanner viewing */    
    var body: some View {
        NavigationView {
            ZStack {
                // background color information
                Color(.systemBackground)
                    .ignoresSafeArea()

                ScrollView {
                    /* view title (same as app title) */
                    HStack {
                        Text("  What goes in... comes out...")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color(.systemBackground)).colorInvert()
                        Spacer()
                    }

                    // MARK: - Food/drink tracking
                    FoodDrinkInputView()
                    
                    // MARK: - Poo input
                    PooInputView()
                    
                    // MARK: - Exercise input
                    ExerciseInputView()
                    
                    
                    // MARK: - Sleep input
                    SleepInputView()
                    
                    // MARK: - Meditation input
                    MeditationInputView()
                }
            }
            .foregroundColor(.red)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



// MARK: - PREVIEW
struct InputV_Previews: PreviewProvider {
    static var previews: some View {
        InputView()
    }
}

