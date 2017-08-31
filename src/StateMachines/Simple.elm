module StateMachines.Simple exposing (State(..), StateMapError(..), StateTransitionError(..), hasTransition, mapToState, startState)


type State
    = Start
    | Process
    | Success
    | Failure


type StateMapError
    = UnknownState String


type StateTransitionError
    = UnknownTransition State State


startState : State
startState =
    Start


mapToState : String -> Result StateMapError State
mapToState str =
    case str of
        "Start" ->
            Ok Start

        "Process" ->
            Ok Process

        "Success" ->
            Ok Success

        "Failure" ->
            Ok Failure

        state ->
            Err (UnknownState state)


hasTransition : State -> State -> Result StateTransitionError State
hasTransition source target =
    case ( source, target ) of
        ( Start, Process ) ->
            Ok target

        ( Process, Success ) ->
            Ok target

        ( Process, Failure ) ->
            Ok target

        ( Failure, Start ) ->
            Ok target

        ( _, _ ) ->
            Err (UnknownTransition source target)
