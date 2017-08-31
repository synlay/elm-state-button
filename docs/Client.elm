module Client exposing (..)

import Animated exposing (..)
import App exposing (..)
import FiniteStateMachine exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import StateMachines.Simple as StateMachine exposing (..)
import Types exposing (..)


type Msg
    = SharedMsg Types.Msg
    | ChangeState StateMachine.State


type alias Model =
    { stateMachineModel : FiniteStateMachine.Model }


stateMachineModel : FiniteStateMachine.Model
stateMachineModel =
    newStateMachine
        [ createState StateMachine.Start
            { text = "Start"
            , icon = "glyphicon glyphicon-send"
            , style = "btn btn-primary"
            , disabled = False
            , initAnimation = Just Animated.pulse
            }
        , createState StateMachine.Process
            { text = "Process"
            , icon = "glyphicon glyphicon-time"
            , style = "btn btn-default"
            , disabled = False
            , initAnimation = Just Animated.pulse
            }
        , createState StateMachine.Failure
            { text = "Failure"
            , icon = "glyphicon glyphicon-remove"
            , style = "btn btn-danger"
            , disabled = False
            , initAnimation = Just Animated.shake
            }
        , createState StateMachine.Success
            { text = "Success"
            , icon = "glyphicon glyphicon-ok"
            , style = "btn btn-success"
            , disabled = False
            , initAnimation = Just Animated.pulse
            }
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( { stateMachineModel = stateMachineModel }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeState state ->
            case App.changeState state model.stateMachineModel of
                Ok newStateMachineModel ->
                    ( { model | stateMachineModel = newStateMachineModel }, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.map SharedMsg (App.stateButton model.stateMachineModel)
        , Html.br [] []
        , Html.a [ Html.Attributes.class "btn btn-link", onClick (ChangeState StateMachine.Start) ] [ text "Emit 'Start'" ]
        , Html.a [ Html.Attributes.class "btn btn-link", onClick (ChangeState StateMachine.Process) ] [ text "Emit 'Process'" ]
        , Html.a [ Html.Attributes.class "btn btn-link", onClick (ChangeState StateMachine.Failure) ] [ text "Emit 'Failure'" ]
        , Html.a [ Html.Attributes.class "btn btn-link", onClick (ChangeState StateMachine.Success) ] [ text "Emit 'Success'" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []
