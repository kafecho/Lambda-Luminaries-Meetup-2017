module Angular exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    { name : String
    }


type Msg
    = Name String


model : Model
model =
    { name = "" }


view : Model -> Html Msg
view model =
    div []
        [ input [ value (model.name), onInput Name ] []
        , div [] [ text ("Hello " ++ model.name) ]
        ]


update : Msg -> Model -> Model
update (Name s) model =
    { model | name = s }


main =
    Html.beginnerProgram { model = model, view = view, update = update }
