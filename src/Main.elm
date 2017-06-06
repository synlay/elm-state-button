port module Main exposing (..)

import Machine exposing (..)
import Animated exposing (..)
import Time exposing (millisecond)
import Maybe exposing (Maybe(Just, Nothing))
import Machine exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Animation exposing (..)


-- Types


type Msg
    = FromJs String
    | Animate Animation.Msg
    | InitAnimation Machine.Model


type alias Model =
    Machine.Model


type alias MachineError =
    { message : String
    , error : String
    , state : String
    }


type alias Flag =
    { text : String
    , icon : String
    , style : String
    }


type alias Flags =
    { start : Flag
    , process : Flag
    , succeed : Flag
    , failure : Flag
    }



-- Ports


port state : (String -> msg) -> Sub msg


port change : String -> Cmd msg


port error : MachineError -> Cmd msg



-- Main


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Initialize


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        start =
            Machine.newState
                { identity = "start"
                , text = flags.start.text
                , icon = flags.start.icon
                , style = flags.start.style
                , disabled = False
                , initAnimation = Nothing
                }

        process =
            Machine.newState
                { identity = "process"
                , text = flags.process.text
                , icon = flags.process.icon
                , style = flags.process.style
                , disabled = True
                , initAnimation = Nothing
                }

        succeed =
            Machine.newState
                { identity = "succeed"
                , text = flags.succeed.text
                , icon = flags.succeed.icon
                , style = flags.succeed.style
                , disabled = False
                , initAnimation = Just pulse
                }

        failure =
            Machine.newState
                { identity = "failure"
                , text = flags.failure.text
                , icon = flags.failure.icon
                , style = flags.failure.style
                , disabled = False
                , initAnimation = Just shake
                }

        machine =
            Machine.newMachine start
                [ Machine.newTransition start process
                , Machine.newTransition process succeed
                , Machine.newTransition process failure
                , Machine.newTransition succeed start
                , Machine.newTransition failure start
                ]

        animation =
            update (InitAnimation machine) machine
    in
        ( (Tuple.first animation), change machine.state.identity )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        batch =
            [ state FromJs ]
    in
        case model.state.initAnimation of
            Just animated ->
                Sub.batch (List.append batch [ Animation.subscription Animate [ animated.start ] ])

            Nothing ->
                Sub.batch batch



-- View


viewGetButtonAnimation model =
    case model.state.initAnimation of
        Just animated ->
            Animation.render animated.start

        Nothing ->
            []


viewConstructButtonAnimation model attributes =
    let
        animation =
            viewGetButtonAnimation model
    in
        List.concat [ animation, attributes ]


view : Model -> Html Msg
view model =
    let
        buttonAttributes =
            viewConstructButtonAnimation model
                [ onClick (InitAnimation model)
                , class model.state.style
                , disabled model.state.disabled
                ]
    in
        button buttonAttributes
            [ span []
                [ i [ class model.state.icon, attribute "aria-hidden" "true" ] []
                , text (" " ++ model.state.text)
                ]
            ]



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InitAnimation newModel ->
            case newModel.state.initAnimation of
                Just animated ->
                    let
                        state =
                            newModel.state

                        newInitAnimationStart =
                            Animation.interrupt animated.animation animated.start

                        newInitAnimation =
                            { animated | start = newInitAnimationStart }

                        newAgent =
                            { state | initAnimation = Just newInitAnimation }
                    in
                        ( { newModel | state = newAgent }, Cmd.none )

                Nothing ->
                    ( newModel, Cmd.none )

        FromJs str ->
            case (Machine.changeState str model) of
                Ok newModel ->
                    let
                        animation =
                            update (InitAnimation newModel) model
                    in
                        ( (Tuple.first animation), change newModel.state.identity )

                Err err ->
                    let
                        machineError =
                            { message = toString err, state = model.state.identity, error = str }
                    in
                        ( model, error machineError )

        Animate animMsg ->
            case model.state.initAnimation of
                Just animated ->
                    let
                        state =
                            model.state

                        newInitAnimation =
                            { animated | start = Animation.update animMsg animated.start }

                        newAgent =
                            { state | initAnimation = Just newInitAnimation }
                    in
                        ( { model | state = newAgent }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )
