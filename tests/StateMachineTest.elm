module StateMachineTest exposing (..)

import Animated exposing (..)
import App exposing (..)
import Expect
import Fuzz exposing (int, list, string)
import StateMachines.Simple as StateMachine exposing (..)
import Test exposing (..)
import Types exposing (..)
import FiniteStateMachine exposing (..)


start =
    createState StateMachine.Start
        { text = "Start"
        , icon = "glyphicon glyphicon-send"
        , style = "btn btn-primary"
        , disabled = False
        , initAnimation = Just Animated.pulse
        }


process =
    createState StateMachine.Process
        { text = "Process"
        , icon = "glyphicon glyphicon-time"
        , style = "btn btn-default"
        , disabled = False
        , initAnimation = Just Animated.pulse
        }


success =
    createState StateMachine.Failure
        { text = "Failure"
        , icon = "glyphicon glyphicon-remove"
        , style = "btn btn-danger"
        , disabled = False
        , initAnimation = Just Animated.shake
        }


failure =
    createState StateMachine.Success
        { text = "Success"
        , icon = "glyphicon glyphicon-ok"
        , style = "btn btn-success"
        , disabled = False
        , initAnimation = Just Animated.pulse
        }


states =
    [ start, process, success, failure ]


stateMachine =
    newStateMachine states


traverseStates : List State -> FiniteStateMachine.Model -> Result FiniteStateMachine.StateError FiniteStateMachine.Model
traverseStates stateList machine =
    let
        stateListHead =
            List.head stateList

        stateListTail =
            List.tail stateList
    in
    case stateListHead of
        Just state ->
            case App.changeState state machine of
                Ok newStateMachine ->
                    case stateListTail of
                        Just listTail ->
                            traverseStates listTail newStateMachine

                        Nothing ->
                            Ok newStateMachine

                Err err ->
                    Err err

        Nothing ->
            Ok machine


suite : Test
suite =
    describe "Test Machine"
        [ describe "Unit test machine"
            [ test "transitions start -> process -> succeed" <|
                \() ->
                    case traverseStates [ StateMachine.Process, StateMachine.Success ] stateMachine of
                        Ok machine ->
                            Expect.pass

                        Err err ->
                            Expect.fail (toString err)
            , test "transitions start -> process -> failure -> start" <|
                \() ->
                    case traverseStates [ StateMachine.Process, StateMachine.Failure, StateMachine.Start ] stateMachine of
                        Ok machine ->
                            Expect.pass

                        Err err ->
                            Expect.fail (toString err)
            ]
        ]
