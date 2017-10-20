module Main exposing (..)

import Date exposing (Date)
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


type BlogPost
    = TestBlogPost
    | ElmBlogGithubPart1
    | ElmBlogGithubPart2


type Page
    = Home HomeModel
    | BlogPostPage BlogPost BlogPostModel -- TODO: Maybe move BlogPost to type: BlogPost in BlogPostModel.


type alias BlogPostModel =
    { contentString : String
    , author : String
    , publishedOn : Result String Date

    -- TODO: Do I need to add post type here? type: BlogPost
    }


type alias HomeModel =
    { blogPost : BlogPostModel
    }


type alias Model =
    Page



-- { page : Page
-- , contentString : String
-- }
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
            ( Home <|
                -- TODO: Should I add cases for each page instead of hard-coding Home?
                HomeModel
                    { contentString = blogPostContent
                    , author = "Jared M. Smith"
                    , publishedOn = (Date.fromString "2017-11-13")
                    }
            , Cmd.none
            )

        ElmBlogGithubPart1Loaded (Err _) ->
            ( Home <|
                HomeModel
                    -- TODO: Set correct page.
                    { contentString = "Failed to load Elm Blog Github - Part 1" -- TODO: Use type to get title.
                    , author = "Jared M. Smith"
                    , publishedOn = (Date.fromString "2017-11-13")
                    }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- http


getElmBlogGithubPart1 : Cmd Msg
getElmBlogGithubPart1 =
    "https://absynce.github.io/posts/elm-blog-github-part-1.md"
        |> Http.getString
        |> Http.send ElmBlogGithubPart1Loaded



-- VIEW


view : Model -> Html Msg
view model =
    model
        |> pageResponseToContent
        |> render model


init : ( Model, Cmd Msg )
init =
    ( Home <|
        HomeModel
            { contentString = "Loading..."
            , author = ""
            , publishedOn = (Date.fromString "")
            }
    , getElmBlogGithubPart1
    )



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
    case page of
        Home homeModel ->
            Markdown.toHtml [ class "content" ] homeModel.blogPost.contentString

        BlogPostPage blogPostType blogPostModel ->
            Markdown.toHtml [ class "content" ] blogPostModel.contentString



-- pageToContent : Page -> Html Msg
-- pageToContent page =
--     case page of


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Home _ ->
            "Home"

        BlogPostPage ElmBlogGithubPart1 model ->
            "elm-blog-github - Part 1 - Prove you can code in Elm."

        BlogPostPage ElmBlogGithubPart2 model ->
            "elm-blog-github - Part 2 - Add markdown to your Elm blog hosted on GitHub."

        BlogPostPage TestBlogPost model ->
            "Test Blog Post"
