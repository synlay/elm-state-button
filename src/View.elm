module View exposing (view)

import Animation exposing (..)
import FiniteStateMachine exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Types exposing (..)

renderState : Maybe Types.StateProperties -> Html msg
renderState stateProperties =
    case stateProperties of
        Just stateProperties ->
            let
                state =
                    stateProperties.state

                properties =
                    stateProperties.properties
            in
            Html.span [ alt (toString state) ]
                [ i [ class properties.icon, attribute "aria-hidden" "true" ] []
                , text (" " ++ properties.text)
                ]

        Nothing ->
            Html.span []
                []


viewGetButtonAnimation model =
    case model.current of
        Just stateProperties ->
            let
                state =
                    stateProperties.state

                properties =
                    stateProperties.properties
            in
            case properties.initAnimation of
                Just animated ->
                    Animation.render animated.start

                Nothing ->
                    []

        Nothing ->
            []


viewConstructButtonAnimation model attributes =
    let
        animation =
            viewGetButtonAnimation model
    in
    List.concat [ animation, attributes ]


view : FiniteStateMachine.Model -> Html msg
view model =
    let
        extendAttributes maybeState attributes =
            case maybeState of
                Just state ->
                    List.concat
                        [ attributes
                        , [ class state.properties.style
                          , disabled state.properties.disabled
                          ]
                        ]

                Nothing ->
                    attributes
    in
    Html.button
        (viewConstructButtonAnimation model
            (extendAttributes model.current [
            -- onClick ClickAnimation
            ])
        )
        [ --renderState model.previous,
          renderState model.current
        ]
