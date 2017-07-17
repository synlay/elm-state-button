module Helper exposing (..)

import StateMachines.Simple as StateMachine exposing (..)
import FiniteStateMachine exposing (..)
import Animated exposing (..)
import Types exposing (..)


flagsToModel : List Flag -> FiniteStateMachine.Model
flagsToModel flags =
    let
        states =
            flagsToStates flags
    in
    { current = mapStateToStateProperties FiniteStateMachine.startState states
    , previous = Nothing
    , states = states
    }


flagsToStates : List Flag -> List StateProperties
flagsToStates flags =
    List.filterMap flagToState flags


flagToState : Flag -> Maybe StateProperties
flagToState flag =
    case FiniteStateMachine.mapToState flag.name of
        Ok state ->
            let
                properties =
                    { --identity = flag.name,
                      text = flag.text
                    , icon = flag.icon
                    , style = flag.style
                    , disabled = flag.disabled
                    , initAnimation = Animated.mapToAnimation flag.initAnimation
                    }
            in
            Just (StateProperties state properties)

        Err error ->
            let
                _ =
                    Debug.log "Error: mapToState" error
            in
            Nothing


mapStateToStateProperties : StateMachine.State -> List StateProperties -> Maybe StateProperties
mapStateToStateProperties state states =
    case queryStateProperties state states of
        Ok stateWithProperties ->
            Just stateWithProperties

        Err error ->
            let
                _ =
                    Debug.log "Error: queryStateProperties" error
            in
            Nothing
