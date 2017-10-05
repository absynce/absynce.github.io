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
    | ElmBlogGithubPart2


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



-- "... is wherever I want to be."
--
-- absynce developer blog written in Elm coming soon.
--
-- I've been writing software for over 10 years. The beauty, simplicity and usefulness of [Elm](http://elm-lang.org/) is what brought me out of my clamshell and prompted me to write this.


pageToContent : Page -> Html Msg
pageToContent page =
    case page of
        Home ->
            Markdown.toHtml [ class "content" ] """

# Learn Elm while writing a blog on GitHub Pages


Share your journey into Elm while learning it by creating a blog in Elm and hosting it for free on GitHub Pages.

## Step 0. - Work through _An Introduction to Elm_

If you haven't walked through [An Introduction to Elm](https://guide.elm-lang.org/) do that now. And by "walk through" I mean do the examples and play with the code. It's easy and fun to read. By the end you'll have your environment set up and be ready to start writing your blog in Elm.

## Step 1. - Write some Elm code

Create a `src/Main.elm` file with the following code:

```
module Main exposing (main)

import Html exposing (..)


main =
    text "Here's what I learned while exploring Elm..."
```

## Step 2. - Compile your Elm code

```
elm make src/Main.elm --output=elm.js
```

The first time you compile you'll get the following:

```nohighlight
Some new packages are needed. Here is the upgrade plan.

  Install:
    elm-lang/core 5.1.1
    elm-lang/html 2.0.0
    elm-lang/virtual-dom 2.0.4

Do you approve of this plan? [Y/n]
```

Press Enter. You should see some packages download and finally:

```nohighlight
Successfully generated elm.js
```

## Step 3. - Add index.html

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

GitHub Pages looks for `index.html` when serving your site at username.github.io.

This does two important things for Elm:

1. References your compiled Elm app JavaScript output (`elm.js`):
```
    <script src="elm.js"></script>
```

2. Tells Elm to run your app full screen:
```
    var app = Elm.Main.fullscreen();
```

## Step 4. - Run your app locally

```
elm reactor
```

This will start the built-in Elm web server. Go to `http://localhost:8000/index.html`.

<div class="notice">
If you get `elm-reactor: bind: resource busy (Address already in use)` then specify an open port:

```
elm reactor -p 8088
```
</div>

## Step 5. - Create a GitHub page

[Create a GitHub page](https://pages.github.com/) with your GitHub username: _username.github.io_. Clone your repository locally.


"""

        ElmBlogGithubPart2 ->
            Markdown.toHtml [ class "content" ] """
with the following skeleton similar to [The Elm Architecture section](https://guide.elm-lang.org/architecture/) of An Introduction to Elm.

### Skeleton
```
import Html exposing (..)

main =
    Html.beginnerProgram { model = model, view = view, update = update }


-- Model


type alias Model = { ... }

model : Model
model =
    ...


-- Update


type Msg = Reset | ...

update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> ...
    ...


-- View


view : Model -> Html Msg
view model =
  ...
```

Let's examine the model section. How can we describe what our model is?

```
type alias Model = { ... }

model : Model
model =
    ...
```

To keep it simple, let's say our model is a page.

```
type alias Model = Page
```

Now we need to define `Page`.

```
-- Should I explain this union type, simplify model, or bypass?
type Page = Home
```

This says what our model looks like, but doesn't give it a default value.

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

        ElmBlogGithubPart2 ->
            "elm-blog-github - Part 2 - Add markdown to your Elm blog hosted on GitHub."

        TestBlogPost ->
            "Test Blog Post"
