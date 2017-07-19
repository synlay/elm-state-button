module Update exposing (..)

import Animation exposing (..)
import FiniteStateMachine exposing (..)
import StateMachines.Simple as StateMachine exposing (..)
import Types exposing (..)
import Ports exposing (..)


{- Trigger state button animation. -}


update : Types.Msg -> FiniteStateMachine.Model -> ( FiniteStateMachine.Model, Cmd Types.Msg )
update msg model =
    case msg of
        Types.FromJs str ->
            handleJavaScriptUpdate model str

        Types.Animate aniMsg ->
            handleAnimationUpdate model aniMsg

        InitAnimation ->
            ( triggerButtonAnimation model, Cmd.none )


triggerStateChange : StateMachine.State -> FiniteStateMachine.Model -> Result FiniteStateMachine.StateError FiniteStateMachine.Model
triggerStateChange state model =
    case FiniteStateMachine.changeState state model of
        Ok newModel ->
            Ok (triggerButtonAnimation newModel)

        Err error ->
            let
                _ =
                    Debug.log "StateButtonError" error
            in
            Err error


triggerButtonAnimation : FiniteStateMachine.Model -> FiniteStateMachine.Model
triggerButtonAnimation model =
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
                    { model | current = Just (StateProperties currentStateProperties.state newProperties) }

                Nothing ->
                    model

        Nothing ->
            model



{- Handle state updates derived from JavaScript-Ports.
   To do so change the models current state properties
-}


handleJavaScriptUpdate : FiniteStateMachine.Model -> String -> ( FiniteStateMachine.Model, Cmd msg )
handleJavaScriptUpdate model str =
    case FiniteStateMachine.mapToState str of
        Ok state ->
            case triggerStateChange state model of
                Ok newModel ->
                    ( newModel, change (toString state) )

                Err error ->
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


handleAnimationUpdate : FiniteStateMachine.Model -> Animation.Msg -> ( FiniteStateMachine.Model, Cmd msg )
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
