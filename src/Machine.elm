module Machine exposing (Model, Error, State, Transition, newMachine, newState, newTransition, changeState)

import Dict exposing (..)
import Tuple exposing (..)
import Animation exposing (..)


-- Types


type Error
    = TransitionError


type alias State =
    { identity : String
    , text : String
    , icon : String
    , disabled : Bool
    , initAnimation : Maybe Animated
    }


type alias Animated =
    { start : Animation.State
    , animation : List Animation.Step
    }


type alias Transition =
    ( State, State )


type alias Transitions =
    Dict String Transition


type alias Model =
    { state : State
    , transitions : Transitions
    }



-- Machine


newMachine : State -> List ( String, Transition ) -> Model
newMachine state transitions =
    { state = state
    , transitions = (Dict.fromList transitions)
    }


newState : State -> State
newState state =
    state


newTransition : State -> State -> ( String, Transition )
newTransition source target =
    ( source.identity ++ ":" ++ target.identity, ( source, target ) )


changeState : String -> Model -> Result Error Model
changeState key model =
    let
        identity =
            model.state.identity ++ ":" ++ key
    in
        -- Dict.get: O(log n)
        case Dict.get identity model.transitions of
            Just transition ->
                Ok { model | state = (Tuple.second transition) }

            Nothing ->
                Err TransitionError
