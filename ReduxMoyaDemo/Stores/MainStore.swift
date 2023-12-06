import Foundation
import ReSwift

// The global application store, which is responsible for managing the appliction state.
let mainStore = Store<AppState>(
    reducer: appReducer,
    state: nil
)
