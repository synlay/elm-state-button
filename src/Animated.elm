port module Animated exposing (Animated, rotate, pulse, shake)

import Animation exposing (..)


-- Types


type alias Animated =
    { start : Animation.State
    , animation : List Animation.Step
    }



-- Animations


rotate : Animated
rotate =
    let
        speed =
            Animation.speed { perSecond = 10.0 }

        start =
            Animation.style [ Animation.rotate3d (turn 0) (turn 0) (turn 0) ]

        animation =
            [ Animation.toWith speed [ Animation.rotate3d (turn 0.25) (turn 0) (turn 0) ]
            , Animation.toWith speed [ Animation.rotate3d (turn 0) (turn 0) (turn 0) ]
            ]
    in
        { start = start, animation = animation }


pulse : Animated
pulse =
    let
        speed =
            Animation.speed { perSecond = 0.5 }

        start =
            Animation.style [ Animation.scale 1 ]

        animation =
            [ Animation.toWith speed [ Animation.scale 1.1 ]
            , Animation.toWith speed [ Animation.scale 1.0 ]
            ]
    in
        { start = start, animation = animation }


shake : Animated
shake =
    let
        speed1 =
            Animation.speed { perSecond = 100.0 }

        speed2 =
            Animation.speed { perSecond = 150.0 }

        start =
            Animation.style [ Animation.translate (px 0) (px 0) ]

        animation =
            [ Animation.toWith speed1 [ Animation.translate (px 4) (px 0) ]
            , Animation.toWith speed1 [ Animation.translate (px -4) (px 0) ]
            , Animation.toWith speed2 [ Animation.translate (px 8) (px 0) ]
            , Animation.toWith speed2 [ Animation.translate (px -8) (px 0) ]
            , Animation.toWith speed2 [ Animation.translate (px 0) (px 0) ]
            ]
    in
        { start = start, animation = animation }
