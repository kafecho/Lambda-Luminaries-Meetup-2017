-- Angular-style binding in Elm


module Angular exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { name : String
    , nbTimes : Int
    }


type Msg
    = Name String
    | NbTimes String


initialModel : Model
initialModel =
    { name = "", nbTimes = 1 }


myView : Model -> Html Msg
myView model =
    div []
        [ input [ value (model.name), onInput Name ] []
        , input [ value (toString model.nbTimes), onInput NbTimes ] []
        , div [] (List.repeat (model.nbTimes) (div [] [ text model.name ]))
        ]


myUpdate : Msg -> Model -> Model
myUpdate msg model =
    case msg of
        Name s ->
            { model | name = s }

        NbTimes s ->
            let
                myInt =
                    String.toInt s |> Result.withDefault 0
            in
                { model | nbTimes = myInt }


main =
    Html.beginnerProgram
        { model = initialModel
        , view = myView
        , update = myUpdate
        }
