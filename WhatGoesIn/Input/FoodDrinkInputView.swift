//
//  FoodDrinkInputView.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/14/21.
//

import SwiftUI

struct FoodDrinkInputView: View {
    @StateObject var viewModel = FoodDrinkInputView.ViewModel()
    
    var body: some View {
        GroupBox(
            label: HStack {
                Text("🥗 Track eating and drinking")
                Spacer()
                NavigationLink(destination: FoodLogView()) {
                    Text("Entries")
                        .underline()
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
        ) {
            // Text input
            GroupBox () {
                HStack{
                    TextField("Enter food", text: $viewModel.item_name, onCommit:  {
                        viewModel.handleTextInput(item: viewModel.item_name)
                        viewModel.item_name = ""
                    })
                    Button("Submit") {
                        viewModel.handleTextInput(item: viewModel.item_name)
                        viewModel.item_name = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
            HStack {
                // Barcode scanner input
                Button(action: {
                    viewModel.isShowingScanner = true
                }) {
                    GroupBox(
                        label: HStack {
                            Image(systemName: "barcode").foregroundColor(Color(.systemBackground)).colorInvert()
                            Text("Barcode")
                        }
                    ) {}
                }.padding(2)
                .sheet(isPresented: $viewModel.isShowingScanner) {
                    CodeScanView(handleScan: viewModel.handleScan)
                }
            }
        }.padding(2)
    }
}

// MARK: - Food log view

struct FoodLogView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Food.entity(), sortDescriptors: []) var foods: FetchedResults<Food>
    
    var body: some View {
        VStack {
            List {
                ForEach(foods, id: \.id) { food in
                    HStack {
                        Text(food.name ?? "Unknown")
                        Spacer()
                        Button("Edit") {
                            
                        }
                    }
                }
                .onDelete { indexSet in         /* allows deletion from list */
                    for index in indexSet {     /* might be able to abstract to viewmodel */
                        moc.delete(foods[index])
                    }
                    do {
                        try moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .navigationBarTitle("Food entries")
   }
}


struct FoodDrinkInputView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDrinkInputView()
    }
}
