module Route
    exposing
        ( Route(..)
        , fromLocation
        , setUrl
        )

import Navigation
import Page.BlogPost as BlogPost
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


type Route
    = Home
    | Post BlogPost.Slug


{-| Route parser based on [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm#L26).
-}
route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (Url.s "")
        , Url.map Post (Url.s "!" </> Url.s "post" </> BlogPost.slugParser)
        , Url.map Post (Url.s "post" </> BlogPost.slugParser)
        ]


routeToString : Route -> String
routeToString route =
    let
        segments =
            case route of
                Home ->
                    [ "" ]

                Post slug ->
                    [ "post", slug |> BlogPost.slugToString ]

        cons =
            (::)
    in
        segments
            |> cons "#!"
            |> String.join "/"


{-| Use this to change the page.

It will trigger SetRoute from the program because it calls `newUrl`
which calls `Navigation.newUrl`.

-}
setUrl : Route -> Cmd msg
setUrl =
    newUrl


newUrl : Route -> Cmd msg
newUrl =
    routeToString >> Navigation.newUrl


fromLocation : Navigation.Location -> Maybe Route
fromLocation location =
    location
        |> parseHash route
