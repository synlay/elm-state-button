module Update exposing (..)

import Animation exposing (..)
import FiniteStateMachine exposing (..)
import Types exposing (..)


{- Handle state updates derived from JavaScript-Ports.
   To do so change the models current state properties
-}


handleJavaScriptUpdate : FiniteStateMachine.Model -> String -> ( FiniteStateMachine.Model, Cmd Types.Msg )
handleJavaScriptUpdate model str =
    case FiniteStateMachine.mapToState str of
        Ok state ->
            case FiniteStateMachine.changeState state model of
                Ok newModel ->
                    ( newModel, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "Error: changeState" error
                    in
                    ( model, Cmd.none )

        Err error ->
            let
                _ =
                    Debug.log "Error: mapToState" error
            in
            ( model, Cmd.none )



{- Handle animation updates messages from Animation library.
   To do so change the models current state properties
-}


handleAnimationUpdate : FiniteStateMachine.Model -> Animation.Msg -> ( FiniteStateMachine.Model, Cmd Types.Msg )
handleAnimationUpdate model msg =
    case model.current of
        Just currentStateProperties ->
            case currentStateProperties.properties.initAnimation of
                Just animated ->
                    let
                        properties =
                            currentStateProperties.properties

                        newInitAnimation =
                            { animated | start = Animation.update msg animated.start }

                        newProperties =
                            { properties | initAnimation = Just newInitAnimation }
                    in
                    ( { model | current = Just (StateProperties currentStateProperties.state newProperties) }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Nothing ->
            ( model, Cmd.none )



{- Handle state button click events.
   To do so change the models current state properties
-}


handleButtonClick : FiniteStateMachine.Model -> ( FiniteStateMachine.Model, Cmd Types.Msg )
handleButtonClick model =
    case model.current of
        Just currentStateProperties ->
            case currentStateProperties.properties.initAnimation of
                Just animated ->
                    let
                        properties =
                            currentStateProperties.properties

                        newInitAnimationStart =
                            Animation.interrupt animated.animation animated.start

                        newInitAnimation =
                            { animated | start = newInitAnimationStart }

                        newProperties =
                            { properties | initAnimation = Just newInitAnimation }
                    in
                    ( { model | current = Just (StateProperties currentStateProperties.state newProperties) }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Nothing ->
            ( model, Cmd.none )
