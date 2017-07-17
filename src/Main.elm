port module Main exposing (changeState, newModel, newState, stateButton)

import Animated exposing (..)
import Animation exposing (..)
import FiniteStateMachine exposing (..)
import Helper exposing (..)
import Html exposing (..)
import StateMachines.Simple as StateMachine exposing (..)
import Types exposing (..)
import Update exposing (..)
import View exposing (..)


type Msg
    = FromJs String
    | Animate Animation.Msg



-- JavaScript


port state : (String -> msg) -> Sub msg


port change : String -> Cmd msg


port error : StateMachineError -> Cmd msg



-- Elm


newState : StateMachine.State -> Properties -> StateProperties
newState state properties =
    { state = state
    , properties = properties
    }


newModel : List StateProperties -> FiniteStateMachine.Model
newModel states =
    { previous = Nothing
    , current = mapStateToStateProperties FiniteStateMachine.startState states
    , states = states
    }


changeState : StateMachine.State -> FiniteStateMachine.Model -> Result FiniteStateMachine.StateError FiniteStateMachine.Model
changeState state model =
    triggerStateChange state model


stateButton : FiniteStateMachine.Model -> Html msg
stateButton model =
    View.view model



-- Main


init : List Flag -> ( FiniteStateMachine.Model, Cmd Msg )
init flags =
    ( flagsToModel flags, Cmd.none )


main : Program (List Flag) FiniteStateMachine.Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> FiniteStateMachine.Model -> ( FiniteStateMachine.Model, Cmd Msg )
update msg model =
    case msg of
        FromJs str ->
            handleJavaScriptUpdate model str

        Animate aniMsg ->
            handleAnimationUpdate model aniMsg


subscriptions : FiniteStateMachine.Model -> Sub Msg
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
