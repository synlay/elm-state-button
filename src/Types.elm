module Types exposing (..)

import Animated exposing (..)
import StateMachines.Simple as StateMachine exposing (..)

type alias StateProperties =
    { state : StateMachine.State
    , properties : Properties
    }


type alias Flag =
    { name : String
    , text : String
    , icon : String
    , style : String
    , disabled : Bool
    , initAnimation : Maybe String
    }


type alias Properties =
    { --identity : String,
      text : String
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
