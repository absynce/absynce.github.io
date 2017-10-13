module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Markdown exposing (..)


main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }



-- MODEL


type Page
    = Home
    | TestBlogPost
    | ElmBlogGithubPart2


type alias BlogModel =
    { contentString : String }


type alias Model =
    { page : Page
    , contentString : String
    }



-- UPDATE


type Msg
    = Reset
    | ElmBlogGithubPart1Msg
    | ElmBlogGithubPart1Loaded (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            init

        ElmBlogGithubPart1Msg ->
            ( model, getElmBlogGithubPart1 )

        ElmBlogGithubPart1Loaded (Ok blogPostContent) ->
            ( { page = Home, contentString = blogPostContent }, Cmd.none )

        ElmBlogGithubPart1Loaded (Err _) ->
            init



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- http


getElmBlogGithubPart1 : Cmd Msg
getElmBlogGithubPart1 =
    Http.send ElmBlogGithubPart1Loaded (Http.getString "https://absynce.github.io/posts/elm-blog-github-part-1.md")



-- VIEW


view : Model -> Html Msg
view model =
    model
        |> pageResponseToContent
        |> render model.page


init : ( Model, Cmd Msg )
init =
    ( { page = Home, contentString = "Hello, World" }, getElmBlogGithubPart1 )



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


pageResponseToContent page =
    Markdown.toHtml [ class "content" ] page.contentString



-- pageToContent : Page -> Html Msg
-- pageToContent page =
--     case page of
--         Home ->
--             Markdown.toHtml [ class "content" ] """
--
-- # Learn Elm while writing a blog on GitHub Pages
--
--
-- Share your journey into Elm while learning it by creating a blog in Elm and hosting it for free on GitHub Pages.
--
-- ## Step 0. - Work through _An Introduction to Elm_
--
-- If you haven't walked through [An Introduction to Elm](https://guide.elm-lang.org/) do that now. And by "walk through" I mean do the examples and play with the code. It's easy and fun to read. By the end you'll have your environment set up and be ready to start writing your blog in Elm.
--
-- ## Step 1. - Write some Elm code
--
-- Create a `src/Main.elm` file with the following code:
--
-- ```
-- module Main exposing (main)
--
-- import Html exposing (..)
--
--
-- main =
--     text "Here's what I learned while exploring Elm..."
-- ```
--
-- ## Step 2. - Compile your Elm code
--
-- ```bash
-- elm make src/Main.elm --output=elm.js
-- ```
--
-- The first time you compile you'll get the following:
--
-- ```nohighlight
-- Some new packages are needed. Here is the upgrade plan.
--
--   Install:
--     elm-lang/core 5.1.1
--     elm-lang/html 2.0.0
--     elm-lang/virtual-dom 2.0.4
--
-- Do you approve of this plan? [Y/n]
-- ```
--
-- Press Enter. You should see some packages download and finally:
--
-- ```nohighlight
-- Successfully generated elm.js
-- ```
--
-- ## Step 3. - Add index.html
--
-- Fire up your favorite text editor. Add the following to index.html in the root of your project:
--
-- ```
-- <!DOCTYPE html>
-- <html>
--   <head>
--     <meta charset="utf-8">
--     <title>your blog title</title>
--     <script src="elm.js"></script>
--   </head>
--   <body id="page-body">
--     <script>
--       var app = Elm.Main.fullscreen(null);
--     </script>
--   </body>
-- </html>
-- ```
--
-- GitHub Pages looks for `index.html` when serving your site at username.github.io.
--
-- This does two important things for Elm:
--
-- 1. References your compiled Elm app JavaScript output (`elm.js`):
-- ```
--     <script src="elm.js"></script>
-- ```
--
-- 2. Tells Elm to run your app full screen:
-- ```
--     var app = Elm.Main.fullscreen();
-- ```
--
-- ## Step 4. - Run your app locally
--
-- ```bash
-- elm reactor
-- ```
--
-- This will start the built-in Elm web server.
--
-- <div class="notice">
-- If you get `elm-reactor: bind: resource busy (Address already in use)` then specify an open port:
--
-- ```
-- elm reactor -p 8088
-- ```
-- </div>
--
-- Go to `http://localhost:8000/index.html`.
--
-- You should see the text "Here's what I learned while exploring Elm...".
--
-- You've written an application! Granted it doesn't do much yet, but you can get pretty far with good content.
--
-- Next we're going to work on publishing it.
--
-- ## Step 5. - Create a GitHub page
--
-- [Create a GitHub page](https://pages.github.com/) with your GitHub username: _username.github.io_.
--
-- Clone your repository locally.
--
--
-- ## Step 6. - Publish it!
--
-- Commit your code. You can ignore `elm-stuff`.
--
-- <div class="notice">
-- Make sure you commit `elm.js` too.
--
-- <p>
-- We typically ignore compiled code, but this simplifies the steps for this exercise.
-- </p>
-- </div>
--
-- Push your commit(s) to GitHub.
--
-- Woohoo! You've just hosted an Elm blog on GitHub Pages.
--
-- Go to _username.github.io_ and check it out!
--
-- ## Next steps
--
-- In the next post we'll make the site more interesting with a title and content section.
-- """
--
--         ElmBlogGithubPart2 ->
--             Markdown.toHtml [ class "content" ] """
-- with the following skeleton similar to [The Elm Architecture section](https://guide.elm-lang.org/architecture/) of An Introduction to Elm.
--
-- ### Skeleton
-- ```
-- import Html exposing (..)
--
-- main =
--     Html.beginnerProgram { model = model, view = view, update = update }
--
--
-- -- Model
--
--
-- type alias Model = { ... }
--
-- model : Model
-- model =
--     ...
--
--
-- -- Update
--
--
-- type Msg = Reset | ...
--
-- update : Msg -> Model -> Model
-- update msg model =
--   case msg of
--     Reset -> ...
--     ...
--
--
-- -- View
--
--
-- view : Model -> Html Msg
-- view model =
--   ...
-- ```
--
-- Let's examine the model section. How can we describe what our model is?
--
-- ```
-- type alias Model = { ... }
--
-- model : Model
-- model =
--     ...
-- ```
--
-- To keep it simple, let's say our model is a page.
--
-- ```
-- type alias Model = Page
-- ```
--
-- Now we need to define `Page`.
--
-- ```
-- -- Should I explain this union type, simplify model, or bypass?
-- type Page = Home
-- ```
--
-- This says what our model looks like, but doesn't give it a default value.
--
-- """
--
--         TestBlogPost ->
--             Markdown.toHtml [ class "content" ] """
--
-- # Test Blog Post
--
-- Test blog post content.
-- """


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Home ->
            "Home"

        ElmBlogGithubPart2 ->
            "elm-blog-github - Part 2 - Add markdown to your Elm blog hosted on GitHub."

        TestBlogPost ->
            "Test Blog Post"
