port module App exposing (changeState, createState, newStateMachine, stateButton)

{-| Elm state button based on a simple state machine


# StateButton

@docs createState
TODO
@docs newStateMachine
TODO
@docs changeState
TODO
@docs stateButton
TODO

-}

import Animated exposing (..)
import Animation exposing (..)
import FiniteStateMachine exposing (..)
import Helper exposing (..)
import Html exposing (..)
import Ports exposing (..)
import StateMachines.Simple as StateMachine exposing (..)
import Types exposing (..)
import Update exposing (..)
import View exposing (..)


-- JavaScript


port state : (String -> msg) -> Sub msg


port change : String -> Cmd msg


port error : StateMachineError -> Cmd msg



-- Elm


createState : StateMachine.State -> Properties -> StateProperties
createState state properties =
    { state = state
    , properties = properties
    }


newStateMachine : List StateProperties -> FiniteStateMachine.Model
newStateMachine states =
    { previous = Nothing
    , current = mapStateToStateProperties FiniteStateMachine.startState states
    , states = states
    }


changeState : StateMachine.State -> FiniteStateMachine.Model -> Result FiniteStateMachine.StateError FiniteStateMachine.Model
changeState state model =
    triggerStateChange state model


stateButton : FiniteStateMachine.Model -> Html Types.Msg
stateButton model =
    View.view model



-- Main


main : Program (List Flag) FiniteStateMachine.Model Types.Msg
main =
    Html.programWithFlags
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = subscriptions
        }


init : List Flag -> ( FiniteStateMachine.Model, Cmd Types.Msg )
init flags =
    ( flagsToModel flags, Cmd.none )


subscriptions : FiniteStateMachine.Model -> Sub Types.Msg
subscriptions model =
    let
        batch =
            [ state FromJs ]
    in
    case model.current of
        Just stateProperties ->
            let
                properties =
                    stateProperties.properties
            in
            case properties.initAnimation of
                Just animated ->
                    Sub.batch (List.append batch [ Animation.subscription Animate [ animated.start ] ])

                Nothing ->
                    Sub.batch batch

        Nothing ->
            Sub.batch batch
