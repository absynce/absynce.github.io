module Icons exposing
    ( gitHub
    , linkedIn
    , twitter
    )

import FeatherIcons
import Html exposing (Html)
import Html.Attributes exposing (class)


gitHub : Html msg
gitHub =
    FeatherIcons.github |> toHtml


linkedIn : Html msg
linkedIn =
    FeatherIcons.linkedin |> toHtml


twitter : Html msg
twitter =
    FeatherIcons.twitter |> toHtml


toHtml : FeatherIcons.Icon -> Html msg
toHtml icon =
    Html.span [ class "svg-icon" ]
        [ FeatherIcons.toHtml [] icon
        ]
