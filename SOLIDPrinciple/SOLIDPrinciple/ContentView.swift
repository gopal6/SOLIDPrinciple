import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.comments, id: \.id) { comment in
                    Text("\(comment.name)")
                }
            }
            .onAppear() {
                vm.getComments()
            }
        }
        
    }
}

#Preview {
    ContentView()
}
