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
            [ h1 [ class "title" ] [ page |> pageToTitle |> text ]
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

I've been writing software for over 10 years. The beauty, simplicity and usefulness of [Elm](http://elm-lang.org/) is what brought me out of my clamshell and prompted me to write this.

# Learning Elm by writing a SPA blog with Github pages


Share your journey into Elm while learning it by creating an Elm SPA blog and hosting it for free on GitHub Pages.

## Step 0. - Read _An Introduction to Elm_

If you haven't walked through [An Introduction to Elm](https://guide.elm-lang.org/) do that now. It's easy and fun to read. By the end you'll have your environment set up and be ready to start writing your blog in Elm.

## Step 1. - Create a GitHub page

[Create a GitHub page](https://pages.github.com/) with your GitHub username: username.github.io. Clone your repo locally.

## Step 2. - Add index.html

Fire up your favorite text editor. Add the following to index.html in the root of your project:

```
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>your blog title</title>
    <script src="elm.js"></script>
  </head>
  <body id="page-body">
    <script>
      var app = Elm.Main.fullscreen(null);
    </script>
  </body>
</html>
```

This does two important things for Elm:

1. References your soon-to-be compiled Elm app JavaScript output
```
    <script src="elm.js"></script>
```

2. Tells Elm to run your app full screen.
```
    var app = Elm.Main.fullscreen(null);
```

<aside class="notice">
    There's an intentional error in the JavaScript you'll fix once you've set up the Elm application.
</aside>

Now that you have a basic idea of the syntax and architecture of Elm apps

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
