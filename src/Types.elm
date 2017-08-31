module Types exposing (..)

import Animated exposing (..)
import Animation exposing (..)
import StateMachines.Simple as StateMachine exposing (..)


type alias StateProperties =
    { state : StateMachine.State
    , properties : Properties
    }



-- Flags are untyped JSONs from JS-init process


type Msg
    = FromJs String
    | InitAnimation
    | Animate Animation.Msg


type alias Flag =
    { name : String
    , text : String
    , icon : String
    , style : String
    , disabled : Bool
    , initAnimation : Maybe String
    }


type alias Properties =
    { text : String
    , icon : String
    , style : String
    , disabled : Bool
    , initAnimation : Maybe Animated.Model
    }


type alias StateMachineError =
    { message : String
    , error : String
    , state : String
    }
