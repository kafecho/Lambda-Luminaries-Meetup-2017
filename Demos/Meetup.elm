module Meetup exposing (..)


type Lang
    = Haskell
    | Clojure
    | Elm
    | Scala


type alias Person =
    { name : String
    , lang : Lang
    }


attendees : List Person
attendees =
    [ Person "Guillaume" Elm
    , Person "Andreas" Scala
    , Person "Handré" Haskell
    ]
