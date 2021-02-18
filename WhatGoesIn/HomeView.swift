// LANDING VIEW

import CodeScanner
import SwiftUI

struct HomeView: View {
    let persistenceController = PersistenceController.shared

    var body: some View {
        TabView {

            // MARK: - USER INPUT
            InputView()
                .tabItem {
                    Image(systemName: "plus.diamond")
                    Text("Inputs")
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)


            // MARK: - ANALYTICS
            AnalyticsView()
                .tabItem {
                    Image(systemName: "doc.text.below.ecg")
                    Text("Analytics")
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            
            // MARK: - POO PICKER
            CommunityView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Community")
                }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = UIColor(Color(.white))
        }
        .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
