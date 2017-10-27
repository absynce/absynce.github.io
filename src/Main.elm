port module Main exposing (..)

import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import List
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


type alias BlogPostModel =
    { contentString : String
    , author : String
    , publishedOn : Result String Date
    , title : String
    , getContentCmd : Cmd Msg

    -- , : BlogPost
    -- TODO: Do I need to add post type here? type: BlogPost
    }


elmBlogGithubPart1 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-11-13")
    , title = "elm-blog-github - Part 1 - Prove you can code in Elm."
    , getContentCmd = getElmBlogGithubPart1
    }


elmBlogGithubPart2 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-11-20")
    , title = "elm-blog-github - Part 2 - Add markdown to your Elm blog hosted on GitHub."
    , getContentCmd = Cmd.none
    }


type alias HomeModel =
    { blogPost : BlogPostModel
    }


type Page
    = Home HomeModel
    | BlogPostPage BlogPostModel -- TODO: Maybe move BlogPost to type: BlogPost in BlogPostModel.


type alias Model =
    Page



-- UPDATE


type Msg
    = Reset
    | ElmBlogGithubPart1Msg
    | ElmBlogGithubPart1Loaded (Result Http.Error String)
    | TransitionTo Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            init

        ElmBlogGithubPart1Msg ->
            ( model, getElmBlogGithubPart1 )

        ElmBlogGithubPart1Loaded (Ok blogPostContent) ->
            let
                newBlogPost =
                    { elmBlogGithubPart1 | contentString = blogPostContent }

                newModel =
                    case model of
                        Home homeModel ->
                            Home <| HomeModel newBlogPost

                        BlogPostPage blogPostModel ->
                            BlogPostPage newBlogPost
            in
                ( newModel, initHighlighting () )

        ElmBlogGithubPart1Loaded (Err err) ->
            let
                newBlogPost =
                    { elmBlogGithubPart1 | contentString = "Failed to load Elm Blog Github - Part 1: " ++ (toString err) }

                newModel =
                    case model of
                        Home homeModel ->
                            Home <| HomeModel newBlogPost

                        BlogPostPage blogPostModel ->
                            BlogPostPage newBlogPost
            in
                ( newModel, Cmd.none )

        TransitionTo (Home homeModel) ->
            init

        TransitionTo (BlogPostPage blogPostModel) ->
            ( BlogPostPage blogPostModel, blogPostModel.getContentCmd )



-- Ports


port initHighlighting : () -> Cmd msg



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


blogPosts =
    [ elmBlogGithubPart1, elmBlogGithubPart2 ]


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
            , title = "Loading..."
            , getContentCmd = Cmd.none
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
            div []
                [ Markdown.toHtml [ class "content" ] homeModel.blogPost.contentString
                , div [ class "other-posts" ]
                    [ h2 [] [ text "Other Posts" ]
                    , blogPosts
                        |> List.map (\post -> li [] [ viewBlogPostLink post ])
                        |> ul []
                    ]
                ]

        BlogPostPage blogPostModel ->
            Markdown.toHtml [ class "content" ] blogPostModel.contentString



-- pageToContent : Page -> Html Msg
-- pageToContent page =
--     case page of


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Home _ ->
            "Home"

        BlogPostPage model ->
            model.title



-- BlogPost Views


viewBlogPostLink blogPost =
    button [ onClick <| TransitionTo <| BlogPostPage blogPost ]
        [ text blogPost.title ]
