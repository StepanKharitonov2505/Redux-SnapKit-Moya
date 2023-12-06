import Foundation
import ReSwift

struct AppState {
    var counter: Int
    var imageState: ImageState
    
    init() {
        self.counter = 0
        self.imageState = .inactive
    }
}
