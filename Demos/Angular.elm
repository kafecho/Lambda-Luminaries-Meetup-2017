-- Angular-style biding in Elm


module Angular exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { name : String
    }


type Msg
    = Name String


initialModel : Model
initialModel =
    { name = "" }


myView : Model -> Html Msg
myView model =
    div []
        [ input [ value (model.name), onInput Name ] []
        , div [] [ text ("Hello " ++ model.name) ]
        ]


myUpdate : Msg -> Model -> Model
myUpdate (Name s) model =
    { model | name = s }


main =
    Html.beginnerProgram
        { model = initialModel
        , view = myView
        , update = myUpdate
        }
