port module Main exposing (..)

import Animated exposing (..)
import Animation exposing (..)
import FiniteStateMachine exposing (..)
import Html exposing (..)
import StateMachines.Simple as StateMachine exposing (..)
import Types exposing (..)
import Update exposing (..)
import View exposing (..)


type alias StateMachineError =
    { message : String
    , error : String
    , state : String
    }


port state : (String -> msg) -> Sub msg


port change : String -> Cmd msg


port error : StateMachineError -> Cmd msg


main : Program (List Flag) FiniteStateMachine.Model Types.Msg
main =
    Html.programWithFlags
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }


init : List Flag -> ( FiniteStateMachine.Model, Cmd Types.Msg )
init flags =
    ( flagsToModel flags, Cmd.none )


update : Types.Msg -> FiniteStateMachine.Model -> ( FiniteStateMachine.Model, Cmd Types.Msg )
update msg model =
    case msg of
        Types.FromJs str ->
            let
                newModel =
                    Tuple.first (handleJavaScriptUpdate model str)
            in
            update Types.ClickAnimation newModel

        Types.Animate aniMsg ->
            handleAnimationUpdate model aniMsg

        Types.ClickAnimation ->
            handleButtonClick model


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



--


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
                    { identity = flag.name
                    , text = flag.text
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
