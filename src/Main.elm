module Main exposing (..)

import Html exposing (..)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type Pages
    = Home
    | TestBlogPost


type alias Model =
    Pages


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
    div [] [ text "Home is wherever I want to be. absynce developer blog written in Elm coming soon." ]
