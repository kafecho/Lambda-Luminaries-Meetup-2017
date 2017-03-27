port module Trailer exposing (..)

import Html exposing (..)
import Json.Decode exposing (..)
import Html.Attributes exposing (href, rel, id, class, src, autoplay, controls)
import Html.Events exposing (onClick, on)
import Char exposing (..)
import Keyboard


currentTimeDecoder : Json.Decode.Decoder Float
currentTimeDecoder =
    Json.Decode.at [ "target", "currentTime" ] Json.Decode.float


onTimeUpdate : (Float -> msg) -> Attribute msg
onTimeUpdate msgConstructor =
    on "timeupdate" (Json.Decode.map msgConstructor currentTimeDecoder)


onPlay =
    on "play" (Json.Decode.succeed (Playing True))


onPause =
    on "pause" (Json.Decode.succeed (Playing False))


type Msg
    = TimeUpdate Float
    | Playing Bool
    | Key KeyCode


type alias Model =
    { currentTime : Maybe Float
    , playing : Bool
    }


port setCurrentTime : Float -> Cmd msg


port play : () -> Cmd msg


port pause : () -> Cmd msg


init : ( Model, Cmd Msg )
init =
    ( { playing = False, currentTime = Nothing }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.presses Key


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Key 32 ->
            -- space bar
            let
                cmd =
                    if (model.playing) then
                        pause ()
                    else
                        play ()
            in
                ( model, cmd )

        Key 107 ->
            -- k
            case model.currentTime of
                Nothing ->
                    ( model, Cmd.none )

                Just pos ->
                    ( model, setCurrentTime (pos - 10) )

        Key 108 ->
            -- l
            case model.currentTime of
                Nothing ->
                    ( model, Cmd.none )

                Just pos ->
                    ( model, setCurrentTime (pos + 10) )

        Key 44 ->
            -- <
            case model.currentTime of
                Nothing ->
                    ( model, Cmd.none )

                Just pos ->
                    ( model, Cmd.batch [ pause (), setCurrentTime (pos - 0.04) ] )

        Key 46 ->
            -- >
            case model.currentTime of
                Nothing ->
                    ( model, Cmd.none )

                Just pos ->
                    ( model, Cmd.batch [ pause (), setCurrentTime (pos + 0.04) ] )

        Playing state ->
            ( { model | playing = state }, Cmd.none )

        TimeUpdate currentTime ->
            ( { model | currentTime = Just currentTime }, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ video [ id "video-player", src "trailer.mov", autoplay False, controls False, onPlay, onPause, onTimeUpdate TimeUpdate ] [] ]
        , div [] [ text ("Current time: " ++ toString (Maybe.withDefault 0 model.currentTime)) ]
        , div [] [ text ("Playing: " ++ (toString model.playing)) ]
        ]


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
