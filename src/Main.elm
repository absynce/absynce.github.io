module Main exposing (..)

import Html exposing (..)


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
    render model (text "Home is wherever I want to be. absynce developer blog written in Elm coming soon.")



-- NOTE: Possibly refactor into (Views)/Page.elm like elm-spa-example.


render : Page -> Html Msg -> Html Msg
render page content =
    div []
        [ header []
            [ h1 [] [ page |> pageToTitle |> text ]
            ]
        , div [] [ content ]
        ]


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Home ->
            "Home"

        TestBlogPost ->
            "Test Blog Post"
