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


members =
    [ Person "Guillaume" Elm
    , Person "Andreas" Scala
    , Person "Handré" Haskell
    ]
