port module Animated exposing (Model, mapToAnimation, pulse, rotate, shake)

import Animation exposing (..)


-- Types


type alias Model =
    { start : Animation.State
    , animation : List Animation.Step
    }



-- Mapper


mapToAnimation : Maybe String -> Maybe Model
mapToAnimation maybeName =
    case maybeName of
        Just name ->
            case name of
                "rotate" ->
                    Just rotate

                "pulse" ->
                    Just pulse

                "shake" ->
                    Just shake

                "toLeft" ->
                    Just toLeft

                "toRight" ->
                    Just toRight

                _ ->
                    Nothing

        Nothing ->
            Nothing



-- State change


toLeft : Model
toLeft =
    let
        speed =
            Animation.speed { perSecond = 200.0 }

        start =
            Animation.style [ Animation.translate (percent 0) (percent 0) ]

        animation =
            [ Animation.toWith speed [ Animation.translate (percent -25) (percent 0) ]
            , Animation.toWith speed [ Animation.translate (percent -50) (percent 0) ]
            , Animation.toWith speed [ Animation.translate (percent -75) (percent 0) ]
            , Animation.toWith speed [ Animation.translate (percent -100) (percent 0) ]
            ]
    in
    { start = start, animation = animation }


toRight : Model
toRight =
    let
        speed =
            Animation.speed { perSecond = 200.0 }

        start =
            Animation.style [ Animation.translate (percent 0) (percent 0) ]

        animation =
            [ Animation.toWith speed [ Animation.translate (percent 25) (percent 0) ]
            , Animation.toWith speed [ Animation.translate (percent 50) (percent 0) ]
            , Animation.toWith speed [ Animation.translate (percent 75) (percent 0) ]
            , Animation.toWith speed [ Animation.translate (percent 100) (percent 0) ]
            ]
    in
    { start = start, animation = animation }



-- Animations


rotate : Model
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


pulse : Model
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


shake : Model
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
