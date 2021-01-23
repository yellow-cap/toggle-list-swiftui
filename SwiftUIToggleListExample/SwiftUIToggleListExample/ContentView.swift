import SwiftUI

class DataModel: ObservableObject {
    @Published var toggles: [ToggleModel] = []
}

struct ToggleModel: Hashable {
    init(id: Int, title: String, isActive: Bool) {
        self.id = id
        self.title = title
        self.isActive = isActive
    }

    let id: Int
    let title: String
    let isActive: Bool
}

struct ContentView: View {
    @ObservedObject var dataModel: DataModel = DataModel()
    @State var isActive: Bool = false

    var body: some View {
        VStack {
            if(dataModel.toggles.isEmpty) {
                Text("Loading...")
            } else {
                List {
                    ForEach(self.dataModel.toggles, id: \.self) { model in
                        Toggle(model.title, isOn: Binding<Bool>(
                                get: { model.isActive },
                                set: {
                                    if let index = dataModel.toggles.firstIndex(where: { $0.id == model.id }) {
                                        dataModel.toggles[index] = ToggleModel(
                                                id: model.id, title: model.title, isActive: $0)
                                    }
                                }
                        ))
                    }
                }
            }
        }
                .onAppear {
                    fetchToggles()
                }
    }

    private func fetchToggles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dataModel.toggles = [
                ToggleModel(id: 0, title: "Toggle 0", isActive: false),
                ToggleModel(id: 1, title: "Toggle 1", isActive: true),
                ToggleModel(id: 2, title: "Toggle 2", isActive: false),
                ToggleModel(id: 3, title: "Toggle 3", isActive: true),
                ToggleModel(id: 4, title: "Toggle 4", isActive: false)
            ]
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
