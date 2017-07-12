module Types exposing (Msg(..), Flag)

import Animation exposing (..)
import FiniteStateMachine exposing (..)


type Msg
    = ClickAnimation
    | FromJs String
    | Animate Animation.Msg



type alias Flag =
    { name : String
    , text : String
    , icon : String
    , style : String
    , disabled : Bool
    , initAnimation : Maybe String
    }
