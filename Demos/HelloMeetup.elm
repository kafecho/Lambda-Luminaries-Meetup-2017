module HelloMeetup exposing (..)

import Meetup exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


tease person =
    case person.lang of
        Groovy ->
            "Sorry, are you lost?"

        JavaScript ->
            "You must be dynamic."

        Java ->
            "You like to type..."

        _ ->
            "We all cool."


render : Person -> Html msg
render person =
    li []
        [ text "Hello"
        , text (person.name ++ ". So you are a fan of " ++ toString (person.lang) ++ "." ++ tease person)
        ]


main =
    ul [] (List.map render attendees)
