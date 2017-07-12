module FiniteStateMachine exposing (Model, Properties, StateProperties, changeState, mapToState, queryStateProperties, startState)

import Animated exposing (..)
import StateMachines.Simple as StateMachine exposing (..)


type StateError
    = StatePropsNotFound
    | UndefinedCurrentState
    | UnknownTransition StateMachine.State StateMachine.State


type alias Properties =
    { identity : String
    , text : String
    , icon : String
    , style : String
    , disabled : Bool
    , initAnimation : Maybe Animated.Model
    }


type alias StateProperties =
    { state : StateMachine.State
    , properties : Properties
    }


type alias Model =
    { previous : Maybe StateProperties
    , current : Maybe StateProperties
    , states : List StateProperties
    }


mapToState : String -> Result StateMapError StateMachine.State
mapToState =
    StateMachine.mapToState


startState : StateMachine.State
startState =
    StateMachine.startState



-- TODO: Try to implement such a behaviour
-- changeState : a -> Model -> (a -> b) -> Result StateError Model
-- changeState target model transitions =


changeState : StateMachine.State -> Model -> Result StateError Model
changeState target model =
    case model.current of
        Just current ->
            case hasTransition current.state target of
                Ok state ->
                    case queryStateProperties state model.states of
                        Ok state ->
                            Ok { model | previous = Just current, current = Just state }

                        Err error ->
                            Err error

                Err error ->
                    Err (UnknownTransition current.state target)

        Nothing ->
            Err UndefinedCurrentState


queryStateProperties : StateMachine.State -> List StateProperties -> Result StateError StateProperties
queryStateProperties state states =
    case states of
        [] ->
            Err StatePropsNotFound

        head :: tail ->
            if head.state == state then
                Ok head
            else
                queryStateProperties state tail
