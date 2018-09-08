module Route exposing
    ( Route(..)
    , parser
    , urlHashToUrl
    )

import Http
import Page.BlogPost as BlogPost
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, string, top)


type Route
    = Home
    | Post BlogPost.Slug


{-| Route parser based on [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm#L26).
-}
parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home top
        , Parser.map Post (Parser.s "!" </> Parser.s "post" </> BlogPost.slugParser)
        , Parser.map Post (Parser.s "post" </> BlogPost.slugParser)
        ]


urlHashToUrl : Url -> Url
urlHashToUrl url =
    { url
        | path = url.fragment |> Maybe.withDefault ""
    }
