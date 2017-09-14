module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type Page
    = Home
    | TestBlogPost


type alias Model =
    Page


model : Model
model =
    Home



-- UPDATE


type Msg
    = Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Reset ->
            Home



-- VIEW


view : Model -> Html Msg
view model =
    model
        |> pageToContent
        |> render model



-- NOTE: Possibly refactor into (Views)/Page.elm like elm-spa-example.


render : Page -> Html Msg -> Html Msg
render page content =
    div []
        [ header []
            [ h1 [] [ page |> pageToTitle |> text ]
            ]
        , div [] [ content ]
        ]


pageToContent : Page -> Html Msg
pageToContent page =
    case page of
        Home ->
            Markdown.toHtml [ class "content" ] """
"... is wherever I want to be."

absynce developer blog written in Elm coming soon.

# Learning Elm by writing a SPA blog with Github pages

## Test Code Block

```
import Html exposing (..)

main =
    Html.beginnerProgram { model = model, view = view, update = update }

```
"""

        TestBlogPost ->
            Markdown.toHtml [ class "content" ] """

# Test Blog Post

Test blog post content.
"""


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Home ->
            "Home"

        TestBlogPost ->
            "Test Blog Post"
