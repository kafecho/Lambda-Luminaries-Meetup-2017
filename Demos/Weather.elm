module Weather exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
import Json.Decode exposing (at, string, Decoder, map4)


type alias City =
    { name : String
    , woeid : Int
    }


durban : City
durban =
    City "Durban" 1580913


johannesburg : City
johannesburg =
    City "Johannesburg" 56189422


capeTown : City
capeTown =
    City "Cape Town" 56189455


cities : List City
cities =
    [ durban
    , johannesburg
    , capeTown
    ]


type alias Weather =
    { sunrise : String
    , sunset : String
    , temperature : String
    , conditions : String
    }


type FetchStatus
    = Fetching
    | Fetched Weather
    | FetchFailed


type alias Model =
    { city : City
    , status : FetchStatus
    }


type Msg
    = SelectedWoeid Int
    | WeatherUpdate (Result Http.Error Weather)


init : ( Model, Cmd Msg )
init =
    ( { city = durban, status = Fetching }, getWeather durban.woeid )


lookup : Int -> Maybe City
lookup woeid =
    List.filter (\c -> c.woeid == woeid) cities |> List.head


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectedWoeid woeid ->
            let
                c =
                    lookup woeid |> Maybe.withDefault durban
            in
                ( { model | city = c, status = Fetching }, getWeather c.woeid )

        WeatherUpdate (Ok weather) ->
            ( { model | status = Fetched weather }, Cmd.none )

        WeatherUpdate (Err error) ->
            let
                _ =
                    Debug.log "Error" (toString error)
            in
                ( { model | status = FetchFailed }, Cmd.none )



-- An outgoing HTTP side effect to fetch the weather for a given place identified by a woeid
-- In Elm, the side effect is described as data that goes out and how to handle the data that comes back in.


getWeather : Int -> Cmd Msg
getWeather woeid =
    let
        url =
            "https://query.yahooapis.com/v1/public/yql?q=select * from weather.forecast where woeid="
                ++ (toString woeid)
                ++ " and u='c'&format=json"

        request =
            Http.get url decodeWeather
    in
        Http.send WeatherUpdate request


decodeWeather : Decoder Weather
decodeWeather =
    map4 Weather
        (at [ "query", "results", "channel", "astronomy", "sunrise" ] string)
        (at [ "query", "results", "channel", "astronomy", "sunset" ] string)
        (at [ "query", "results", "channel", "item", "condition", "temp" ] string)
        (at [ "query", "results", "channel", "item", "condition", "text" ] string)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


renderWeather : Model -> Html Msg
renderWeather model =
    case ( model.city, model.status ) of
        ( city, Fetching ) ->
            div []
                [ text ("Fetching the weather for " ++ city.name ++ "....") ]

        ( city, FetchFailed ) ->
            div []
                [ div [] [ text ("Mmm. Something bad happened when fetching the weather for " ++ city.name ++ "....") ]
                , img [ src "whale.jpg" ] []
                ]

        ( city, Fetched weather ) ->
            div []
                [ text ("Weather for " ++ city.name)
                , div
                    []
                    [ ul []
                        [ li [] [ text ("Sunrise: " ++ weather.sunrise) ]
                        , li [] [ text ("Sunset: " ++ weather.sunset) ]
                        , li [] [ text ("Temperature: " ++ weather.temperature ++ " Celcius") ]
                        , li [] [ text ("Current conditions: " ++ weather.conditions) ]
                        ]
                    ]
                ]


view : Model -> Html Msg
view model =
    let
        options =
            List.map (\city -> option [ value (toString city.woeid) ] [ text city.name ]) cities
    in
        div []
            [ select
                [ onInput (\s -> String.toInt s |> Result.withDefault durban.woeid |> SelectedWoeid)
                ]
                options
            , div [] [ renderWeather model ]
            ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
