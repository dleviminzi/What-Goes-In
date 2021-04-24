//
//  Analytics.swift
//  whatGoesIn
//
//  Created by Daniel Levi-Minzi on 1/31/21.
//

import SwiftUI
import CoreData

struct AnalyticsView: View {
    @Environment(\.calendar) var calendar
    @StateObject var viewModel = ViewModel()
    @State private var showDetails = false
    @FetchRequest(
        entity: Poop.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Poop.date, ascending: true)
        ]
    ) var poos: FetchedResults<Poop>
    @FetchRequest(
        entity: Food.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Food.date, ascending: true)
        ]
    ) var foods: FetchedResults<Food>
    let persistenceController = PersistenceController.shared
    let pooTypes = ["Hard and Lumpy 😖", "Lumpy Sausage 😣", "Sausage with Cracks 🥳", "Smooth, Soft Snake 🥳",
                    "Jagged Blobs 🤨", "Fluffy Blobs 🥴", "Just Liquid 😩"]
    private var month: DateInterval {
        calendar.dateInterval(of: .month, for: Date())!
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                /* create calendar view of the current month */
                CalendarView(interval: month) { date in
                    Text("30")
                        .hidden()
                        .padding(8)
                        .background(viewModel.assignColor(date: date, poos: poos))      /* assign color based on the poop type */
                        .cornerRadius(10)
                        .padding(.vertical, 4)
                        .overlay(
                            Button(action: {
                                showDetails.toggle()
                                viewModel.dt = date
                            }, label: {
                                Text(String(self.calendar.component(.day, from: date)))
                                    .font(.title3)
                                    .foregroundColor(Color(.systemBackground))
                                    .colorInvert()
                            }).sheet(isPresented: $showDetails) {
                                DetailView(detes: viewModel.getDetails())
                            }
                        )
                }
                ZStack {
                    VStack {
                        Text("Suspect List")
                            .font(.title3)
                        ForEach(0..<10) { i in
                            GroupBox ( label:
                                        HStack {
                                            Text(viewModel.retNthWorst(n: i))
                                            Spacer()
                                        }
                            ) {}.groupBoxStyle(SuspectBoxStyle(col: colorGen(foodName: viewModel.retNthWorst(n: i))))
                        }
                    }
                }
                
//                SuspectListView()
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)

                
                /* this function creates a month of fake data */
                Button(action: {
                    viewModel.spoofData()
                }, label: {
                    Text("spoof data")
                })
            }
        }
        .onAppear(perform: {
            fillInDetails()
            calcCorr()
        })
    }
    
    /* populate the day details for the month */
    func fillInDetails() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        /* adding poos to day details */
        for poo in poos {
            let date = dateFormatter.string(from: poo.date ?? Date())
            let dets: Details = Details(food: [], poo: poo.name!)
            viewModel.dayDetails[date] = dets
        }
        
        /* adding foods to day details */
        for food in foods {
            /* initialize the food log array for later */
            if viewModel.fLog[food.name!] == nil {
                viewModel.fLog[food.name!] = Array(repeating: 0, count: poos.count)
            }
            
            let date = dateFormatter.string(from: food.date ?? Date())
            viewModel.dayDetails[date]?.food!.append(food.name ?? "NOTHING HERE AHHH")
        }
    
        viewModel.pLog = Array(repeating: 0, count: poos.count)

        /* creating fLog and pLog */
        var i = 0
        for (date, details) in (Array(viewModel.dayDetails).sorted {$0.0 < $1.0}) {
            print("\(date):\(details)")
            for f in details.food! {
                viewModel.fLog[f]![i] = 3
                if i+1 < poos.count {
                    viewModel.fLog[f]![i+1] = 2
                }
                if i+2 < poos.count {
                    viewModel.fLog[f]![i+2] = 1
                }
            }
            
            viewModel.pLog[i] = pooScore(pooName: details.poo!)
        
            i += 1
        }
    }
    
    
    func calcCorr() {
        for (food, log) in Array(viewModel.fLog) {
            let pearsonScore: Double = Sigma.pearson(x: log, y: viewModel.pLog) ?? 0.0
            viewModel.foodScores[food] = pearsonScore
            print("\(food):\(pearsonScore)")
        }
        print(viewModel.pLog)
        print(viewModel.fLog["muffin"])
    }
    
    
    /* based on bristol stool chart */
    func pooScore(pooName: String) -> Double {
        switch pooName {
        case "Hard and Lumpy 😖", "Just Liquid 😩":
            return 3
        case "Lumpy Sausage 😣", "Fluffy Blobs 🥴":
            return 2
        case "Jagged Blobs 🤨":
            return 1
        default:
            return 0
        }
    }
    
    func colorGen(foodName: String) -> Color {
        let score: Double = viewModel.foodScores[foodName] ?? 0
        
        if score > 0.25 {
            return Color.red
        }
        else if score > 0 {
            return Color.orange
        }
        else if score > -0.25 {
            return Color.yellow
        }
        else {
            return Color.green
        }
    }

}


extension AnalyticsView {
    class ViewModel: ObservableObject {
        @Environment(\.calendar) var calendar
        
        var dt: Date = Date()

        let persistenceController = PersistenceController.shared
        var moc: NSManagedObjectContext

        init() {
            /* managed object context for persistent storage */
            moc = persistenceController.container.viewContext
        }
        
        /* foodScores are used to sort/color suspect list */
        @Published var foodScores: [String : Double] = [:]
        
        /* day details contain food, poo, etc information per each MM/DD/YYYY */
        @Published var dayDetails: [String: Details] = [:]
                        
        /* maps food to array ordered corresponding to days such that
         * if food eaten that day: 1
         * if food eaten previous day: 0.5
         * otherwise: 0
         */
        var fLog: [String : [Double]] = [:]
        
        /* array corresponding to days with entries determined by pooScore */
        var pLog: [Double] = []
        
        /* returns the nth worst rated food
         * TODO: just run this once, save result and index accordingly */
        func retNthWorst(n: Int) -> String {
            var i = 0
            for (k,_) in (Array(foodScores).sorted {$0.1 > $1.1}) {
                if i == n {
                    return "\(k)"
                }
                i += 1
            }
            return ""   /* there is definitely a better way to do this in Swift */
        }
        
        func getDetails() -> Details {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let dateString = dateFormatter.string(from: self.dt)
            print(dateString)
            
            return dayDetails[dateString]!
        }
        
        /* function to determine color for given date */
        func assignColor(date: Date, poos: FetchedResults<Poop>) -> Color {
            print(poos.count)
            for poo in poos {
                if calendar.isDate(poo.date ?? Date(), inSameDayAs: date) {
                    let type: Int16 = poo.type
                                        
                    switch(type) {
                    case 0, 1:
                        return Color.red
                    case 2, 3:
                        return Color.green
                    case 4:
                        return Color.yellow
                    case 5, 6:
                        return Color.red
                    default:
                        return Color.green
                    }
                }
            }
            
            return Color.green
        }
        
        
        /* test functions */
        func randomColor() -> Color {
            let randomInt = Int.random(in: 0...1)
            if randomInt == 1 {
                return Color.blue
            }
            return Color.red
        }
        
        
        
        /* creates random month of data */
        func spoofData() {
            var month: DateInterval {
                calendar.dateInterval(of: .month, for: Date())!
            }
            let exerciseTypes = ["🧎‍♀️ Yoga", "🚶 Walking", "🤸‍♀️ Core", "🏃‍♀️ Running", "🚴‍♂️ Cycling", "🚣 Rowing", "💃 Dance", "🏋️‍♀️ Lifting"]
            let exerciseLengthsMin = [15, 30, 45, 60, 90, 120]
            
            let sleepLengths = [5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12]
            
            let meditationLengths = [5, 10, 15, 30, 45, 60]
            
            let pooTypes = ["Hard and Lumpy 😖", "Lumpy Sausage 😣", "Sausage with Cracks 🥳", "Smooth, Soft Snake 🥳",
                            "Jagged Blobs 🤨", "Fluffy Blobs 🥴", "Just Liquid 😩"]
            
            let mornFoods = ["bagel", "cereal", "banana", "apple", "blueberries", "yogurt", "pancakes", "bacon", "eggs", "salmon", "muffin", "french toast"]
            let nightFoods = ["pizza", "burger", "kale salad", "chicken breast", "pastrami rueben", "gushi bowl", "sushi", "pasta", "magic feta pasta", "cucumber salad", "chicken soup", "tendies", "french fries", "halibut"]
            
            let dayDurationInSeconds: TimeInterval = 60*60*24

            for (ind, date) in stride(from: month.start, to: month.end, by: dayDurationInSeconds).enumerated() {
                print(ind, date)
                let food = Food(context: moc)
                food.id = UUID()
                food.name = mornFoods.randomElement()!
                food.date = date
                
                let food2 = Food(context: moc)
                food2.id = UUID()
                food2.name = nightFoods.randomElement()!
                food2.date = date
                
                if ind%2 == 0 {
                    let exer = Exercise(context: moc)
                    exer.id = UUID()
                    exer.date = date
                    exer.name = exerciseTypes.randomElement()!
                    exer.length = Int16(exerciseLengthsMin.randomElement()!)
                }
                if ind%3 == 0 {
                    let med = Meditation(context: moc)
                    med.id = UUID()
                    med.date = date
                    med.length = Int16(meditationLengths.randomElement()!)
                }
                let poo = Poop(context: moc)
                poo.id = UUID()
                poo.name = pooTypes.randomElement()!
                poo.type = Int16(pooTypes.firstIndex(of: poo.name!)!)
                poo.date = date

                let sleep = Sleep(context: moc)
                sleep.id = UUID()
                sleep.date = date
                sleep.length = sleepLengths.randomElement()!
                
                do {
                    try self.moc.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct DetailView: View {
    var detes: Details
    
    var body: some View {
        VStack{
            Text("\nFoods Consumed:")
                .font(.title2)
            ForEach(0..<detes.food!.count) { i in
                GroupBox ( label:
                            HStack {
                                Text(detes.food![i])
                                Spacer()
                            }
                ) {}
            }
            Text("Poop Type:")
                .font(.title2)
            GroupBox ( label:
                        HStack {
                            Text(detes.poo ?? "")
                            Spacer()
                        }
            ) {}
            Spacer()
        }
    }
}


/* allows us to create iterable date range (NOT APPLICATION CODE) */
extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}

/* box style for the suspect list */
struct SuspectBoxStyle: GroupBoxStyle {
    var col: Color      /* depends on severity of correlation */
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(col)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

/* details about consumption/excretion per day */
struct Details {
    var food: [String]?
    var poo: String?
}


struct Analytics_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView()
    }
}


