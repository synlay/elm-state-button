module MachineTest exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string)
import Machine exposing (..)
import Animated exposing (..)


start : Machine.State
start =
    Machine.newState
        { identity = "start"
        , text = "start"
        , style = ""
        , icon = ""
        , disabled = False
        , initAnimation = Nothing
        }


process : Machine.State
process =
    Machine.newState
        { identity = "process"
        , text = "process"
        , style = ""
        , icon = ""
        , disabled = True
        , initAnimation = Nothing
        }


succeed : Machine.State
succeed =
    Machine.newState
        { identity = "succeed"
        , text = "succeed"
        , style = ""
        , icon = ""
        , disabled = False
        , initAnimation = Just pulse
        }


failure : Machine.State
failure =
    Machine.newState
        { identity = "failure"
        , text = "failure"
        , style = ""
        , icon = ""
        , disabled = False
        , initAnimation = Just shake
        }


machine : Machine.Model
machine =
    Machine.newMachine start
        [ Machine.newTransition start process
        , Machine.newTransition process succeed
        , Machine.newTransition process failure
        , Machine.newTransition failure start
        ]


traverseStates : List State -> Machine.Model -> Result Error Model
traverseStates stateList machine =
    let
        stateListHead =
            List.head stateList

        stateListTail =
            List.tail stateList
    in
        case stateListHead of
            Just state ->
                case Machine.changeState state.identity machine of
                    Ok newMachine ->
                        case stateListTail of
                            Just listTail ->
                                traverseStates listTail newMachine

                            Nothing ->
                                Ok newMachine

                    Err err ->
                        Err err

            Nothing ->
                Ok machine


testTransition : State -> Machine.Model -> Bool
testTransition state machine =
    case Machine.changeState state.identity machine of
        Ok newMachine ->
            True

        Err error ->
            False


suite : Test
suite =
    describe "Test Machine"
        [ describe "Unit test states"
            [ fuzz string "create random states" <|
                \str ->
                    let
                        state =
                            Machine.newState
                                { identity = str
                                , text = str
                                , style = ""
                                , icon = ""
                                , disabled = False
                                , initAnimation = Just shake
                                }
                    in
                        Expect.equal str state.identity
            , test "state 'start'" <|
                \() ->
                    Expect.equal "start" start.identity
            , test "state 'process'" <|
                \() ->
                    Expect.equal "process" process.identity
            , test "state 'succeed'" <|
                \() ->
                    Expect.equal "succeed" succeed.identity
            , test "state 'failure'" <|
                \() ->
                    Expect.equal "failure" failure.identity
            ]
        , describe "Unit test machine"
            [ test "transitions start -> process -> succeed" <|
                \() ->
                    case traverseStates [ process, succeed ] machine of
                        Ok machine ->
                            Expect.pass

                        Err err ->
                            Expect.fail (toString err)
            , test "transitions start -> process -> failure -> start" <|
                \() ->
                    case traverseStates [ process, failure, start ] machine of
                        Ok machine ->
                            Expect.pass

                        Err err ->
                            Expect.fail (toString err)
            ]
        ]
