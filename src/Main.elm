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
-- Is BlogPost useful?


type BlogPost
    = None
    | ElmBlogGithubPart1
    | ElmBlogGithubPart2


type alias BlogPostModel =
    { contentString : String
    , author : String
    , publishedOn : Result String Date
    , title : String
    , getContentCmd : Cmd Msg
    , entry : BlogPost
    }


elmBlogGithubPart1 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-11-13")
    , title = "elm-blog-github - Part 1 - Prove you can code in Elm."
    , getContentCmd = getElmBlogGithubPart1
    , entry = ElmBlogGithubPart1
    }


elmBlogGithubPart2 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-11-20")
    , title = "elm-blog-github - Part 2 - Add title and content areas."
    , getContentCmd = getElmBlogGithubPart2
    , entry = ElmBlogGithubPart2
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
    | ElmBlogGithubPart2Msg
    | ElmBlogGithubPart2Loaded (Result Http.Error String)
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
                    updateModelBlogPost model newBlogPost
            in
                ( newModel, initHighlighting () )

        ElmBlogGithubPart1Loaded (Err err) ->
            let
                newBlogPost =
                    { elmBlogGithubPart1 | contentString = "Failed to load Elm Blog Github - Part 1: " ++ (toString err) }

                newModel =
                    updateModelBlogPost model newBlogPost
            in
                ( newModel, Cmd.none )

        ElmBlogGithubPart2Msg ->
            ( model, getElmBlogGithubPart2 )

        ElmBlogGithubPart2Loaded (Ok blogPostContent) ->
            let
                newBlogPost =
                    { elmBlogGithubPart2 | contentString = blogPostContent }

                newModel =
                    updateModelBlogPost model newBlogPost
            in
                ( newModel, initHighlighting () )

        ElmBlogGithubPart2Loaded (Err err) ->
            let
                newBlogPost =
                    { elmBlogGithubPart2 | contentString = "Failed to load Elm Blog Github - Part 2: " ++ (toString err) }

                newModel =
                    updateModelBlogPost model newBlogPost
            in
                ( newModel, Cmd.none )

        TransitionTo (Home homeModel) ->
            init

        TransitionTo (BlogPostPage blogPostModel) ->
            ( BlogPostPage blogPostModel, blogPostModel.getContentCmd )


updateModelBlogPost model newBlogPost =
    case model of
        Home homeModel ->
            Home <| HomeModel newBlogPost

        BlogPostPage blogPostModel ->
            BlogPostPage newBlogPost



-- Ports


port initHighlighting : () -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


getElmBlogGithubPart1 : Cmd Msg
getElmBlogGithubPart1 =
    "https://absynce.github.io/posts/elm-blog-github-part-1.md"
        |> Http.getString
        |> Http.send ElmBlogGithubPart1Loaded


getElmBlogGithubPart2 : Cmd Msg
getElmBlogGithubPart2 =
    "https://absynce.github.io/posts/elm-blog-github-part-2.md"
        |> Http.getString
        |> Http.send ElmBlogGithubPart2Loaded



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
    ( initialModel
    , getElmBlogGithubPart1
    )


initialModel =
    Home <|
        HomeModel
            { contentString = "Loading..."
            , author = ""
            , publishedOn = (Date.fromString "")
            , title = "Loading..."
            , getContentCmd = Cmd.none
            , entry = None
            }



-- NOTE: Possibly refactor into (Views)/Page.elm like elm-spa-example.


render : Page -> Html Msg -> Html Msg
render page content =
    div []
        [ header []
            [ h1 [ class "title" ] [ viewHomeLink <| text "absynce.github.io" ]
            ]
        , div [ class "container" ]
            [ content
            , aside []
                [ viewHomeLink <| img [ src "https://gravatar.com/avatar/b10e25a444d72682d875ff745166b91c?s=188" ] []
                , h2 [ class "author-name" ] [ text "Jared M. Smith" ]
                , div [] [ a [ href "https://twitter.com/absynce" ] [ text "@absynce" ] ]
                , p [] [ viewHomeLink <| text "Home" ]
                , viewPostLinks
                ]
            ]
        ]


viewHomeLink child =
    a [ onClick <| TransitionTo <| initialModel, href "#" ] [ child ]



-- "... is wherever I want to be."
--
-- absynce developer blog written in Elm coming soon.
--
-- I've been writing software for over 10 years. The beauty, simplicity and usefulness of [Elm](http://elm-lang.org/) is what brought me out of my clamshell and prompted me to write this.


pageResponseToContent page =
    case page of
        Home homeModel ->
            Markdown.toHtml [ class "content" ] homeModel.blogPost.contentString

        BlogPostPage blogPostModel ->
            Markdown.toHtml [ class "content" ] blogPostModel.contentString


viewPostLinks =
    div [ class "posts" ]
        [ h2 [] [ text "Blog Posts" ]
        , blogPosts
            |> List.map (\post -> li [] [ viewBlogPostLink post ])
            |> ul []
        ]



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
    a
        [ onClick <| TransitionTo <| BlogPostPage blogPost
        , href "#/post"
        ]
        [ text blogPost.title ]
