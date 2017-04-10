module Meetup exposing (..)


type Lang
    = Haskell
    | Clojure
    | Elm
    | Scala
    | Python
    | Java
    | Idris
    | Erlang
    | R
    | JavaScript
    | Rust
    | FSharp
    | Cobol
    | Elixir
    | Groovy


type alias Person =
    { name : String
    , lang : Lang
    }


attendees : List Person
attendees =
    [ Person "Guillaume" Elm
    , Person "Johan" Python
    , Person "Machaba" Java
    , Person "Dyce" Scala
    , Person "Andreas" Idris
    , Person "Lyle" Erlang
    , Person "Alessandro" R
    , Person "Veroon" JavaScript
    , Person "Mike" Clojure
    , Person "Ed" Haskell
    , Person "Justin" Rust
    , Person "Attie" FSharp
    , Person "Gergana" JavaScript
    , Person "Richard" JavaScript
    , Person "Pierre" Cobol
    , Person "Christoph" FSharp
    , Person "Deon" Scala
    , Person "JR" Elixir
    , Person "Handre" Haskell
    , Person "Craig" JavaScript
    , Person "Frank" Groovy
    ]
