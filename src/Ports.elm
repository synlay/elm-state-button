port module Ports exposing (change, error, state)

import Types exposing (..)


port state : (String -> msg) -> Sub msg


port change : String -> Cmd msg


port error : StateMachineError -> Cmd msg
