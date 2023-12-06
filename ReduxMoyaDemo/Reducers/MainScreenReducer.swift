import Foundation
import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {

    // creates a new state if one does not already exist

    var state = state ?? AppState()
    switch action {
    case _ as CounterActionIncrease:
        state.counter += 1
    case _ as CounterActionDecrease:
        state.counter -= 1
    case _ as LoadAction:
        state.imageState = .loading

    default:
        break

    }

    // return the new state

    return state
}
