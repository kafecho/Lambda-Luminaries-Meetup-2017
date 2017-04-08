module PrizeDraw exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Meetup exposing (..)
import Random exposing (..)
import Array exposing (..)


type alias Model =
    { pool : List Person
    , potentialWinner : Maybe Person
    , winners : List Person
    }


type Msg
    = DrawNext
    | RandomPerson (Maybe Person)
    | DrawResult Person
    | SkipTurn Person
    | TakePrize Person


init : ( Model, Cmd Msg )
init =
    ( { pool = attendees
      , potentialWinner = Nothing
      , winners = []
      }
    , Cmd.none
    )


subscriptions model =
    Sub.none


randomPersonGenerator list =
    let
        people =
            Array.fromList list

        nbPeople =
            Array.length people
    in
        Random.map (\i -> Array.get i people) (int 0 (nbPeople - 1))


renderPotentialWinner : Model -> Html Msg
renderPotentialWinner model =
    case model.potentialWinner of
        Nothing ->
            div [] []

        Just person ->
            div []
                [ p [] [ text ("Congrats " ++ person.name ++ "!!!! You've won something, you can skip your turn or accept your prize.") ]
                , button
                    [ onClick (SkipTurn person) ]
                    [ text "Yeah, I skip my turn :-)" ]
                , button [ onClick (TakePrize person) ] [ text "No ways, show me the money!!" ]
                ]


renderPlayers : Model -> Html Msg
renderPlayers model =
    let
        listOfPlayers =
            List.map (\w -> li [] [ text (w.name) ]) model.pool
    in
        div []
            [ div [] [ h1 [] [ text "Players" ] ]
            , ul [] listOfPlayers
            ]


renderWinners : Model -> Html Msg
renderWinners model =
    let
        listOfWinners =
            List.reverse model.winners
                |> List.map (\w -> li [] [ text (w.name ++ ", a fan of " ++ toString w.lang ++ "!") ])
    in
        div []
            [ div [] [ h1 [] [ text "Winners so far" ] ]
            , ul [] listOfWinners
            ]


view : Model -> Html Msg
view model =
    let
        noMoreNames =
            List.isEmpty model.pool

        potentialWinner =
            case model.potentialWinner of
                Nothing ->
                    False

                Just _ ->
                    True
    in
        div []
            [ renderPlayers model
            , renderWinners model
            , div [] [ button [ onClick DrawNext, disabled (noMoreNames || potentialWinner) ] [ text "Draw next winner" ] ]
            , renderPotentialWinner model
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DrawNext ->
            ( model, Random.generate RandomPerson (randomPersonGenerator model.pool) )

        SkipTurn person ->
            let
                updatedPool =
                    List.filter (\p -> p /= person) model.pool
            in
                ( { model
                    | potentialWinner = Nothing
                    , pool = updatedPool
                  }
                , Cmd.none
                )

        TakePrize person ->
            let
                updatedWinners =
                    person :: model.winners

                updatedPool =
                    List.filter (\p -> p /= person) model.pool
            in
                ( { model
                    | potentialWinner = Nothing
                    , winners = updatedWinners
                    , pool = updatedPool
                  }
                , Cmd.none
                )

        RandomPerson maybe ->
            ( { model | potentialWinner = maybe }, Cmd.none )

        _ ->
            ( model, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
