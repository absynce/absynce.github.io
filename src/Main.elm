port module Main exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import List
import Markdown exposing (..)
import Navigation
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


main : Program Never Page Msg
main =
    Navigation.program (routeFromLocation >> SetRoute)
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
    | ElmBlogGithubPart3


type alias BlogPostModel =
    { contentString : String
    , author : String
    , publishedOn : Result String Date
    , slug : Slug
    , title : String
    , getContentCmd : Cmd Msg
    , entry : BlogPost
    }


elmBlogGithubPart1 : BlogPostModel
elmBlogGithubPart1 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-12-13")
    , slug = Slug "elm-blog-github-part-1-host-elm-code-on-github"
    , title = "elm-blog-github - Part 1 - Host Elm code on GitHub"
    , getContentCmd = getElmBlogGithubPart1
    , entry = ElmBlogGithubPart1
    }


elmBlogGithubPart2 : BlogPostModel
elmBlogGithubPart2 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-12-20")
    , slug = Slug "elm-blog-github-part-2-add-title-and-content-areas"
    , title = "elm-blog-github - Part 2 - Add title and content areas"
    , getContentCmd = getElmBlogGithubPart2
    , entry = ElmBlogGithubPart2
    }


elmBlogGithubPart3 : BlogPostModel
elmBlogGithubPart3 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = (Date.fromString "2017-12-27")
    , slug = Slug "elm-blog-github-part-3-add-multiple-pages"
    , title = "elm-blog-github - Part 3 - Add multiple pages"
    , getContentCmd = getElmBlogGithubPart3
    , entry = ElmBlogGithubPart3
    }


type alias HomeModel =
    { blogPost : BlogPostModel
    }


type Page
    = HomePage HomeModel
    | BlogPostPage BlogPostModel -- TODO: Maybe move BlogPost to type: BlogPost in BlogPostModel.



-- | PageNotFound String


type alias Model =
    Page



-- UPDATE


type Msg
    = Reset
    | BlogPostLoaded (Result Http.Error String)
    | TransitionTo Page
    | SetRoute (Maybe Route)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            model
                |> setRoute (Just Home)

        BlogPostLoaded result ->
            blogPostLoaded model result

        TransitionTo (HomePage homeModel) ->
            model
                |> setRoute (Just Home)

        TransitionTo (BlogPostPage blogPostModel) ->
            ( BlogPostPage blogPostModel, blogPostModel.getContentCmd )

        SetRoute maybeRoute ->
            model
                |> setRoute maybeRoute


getPageBlogPost : Page -> BlogPostModel
getPageBlogPost page =
    case page of
        HomePage homeModel ->
            homeModel.blogPost

        BlogPostPage blogPostModel ->
            blogPostModel


updateModelBlogPost : BlogPostModel -> Page -> Page
updateModelBlogPost newBlogPost model =
    case model of
        HomePage homeModel ->
            HomePage <| HomeModel newBlogPost

        BlogPostPage blogPostModel ->
            BlogPostPage newBlogPost


blogPostLoaded : Model -> Result Http.Error String -> ( Model, Cmd Msg )
blogPostLoaded model blogPostResult =
    case blogPostResult of
        Ok blogPostContent ->
            let
                oldBlogPost =
                    model
                        |> getPageBlogPost

                newBlogPost =
                    oldBlogPost
                        |> updateBlogPostContent blogPostContent

                newModel =
                    model
                        |> updateModelBlogPost newBlogPost
            in
                ( newModel, initHighlighting () )

        Err err ->
            let
                newContentString =
                    err
                        |> toString
                        |> (++) "Failed to load Elm Blog Github - Part 2: "

                oldBlogPost =
                    model
                        |> getPageBlogPost

                newBlogPost =
                    oldBlogPost
                        |> updateBlogPostContent newContentString

                newModel =
                    model
                        |> updateModelBlogPost newBlogPost
            in
                ( newModel, Cmd.none )


updateBlogPostContent : String -> BlogPostModel -> BlogPostModel
updateBlogPostContent newContent blogPost =
    { blogPost | contentString = newContent }



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
        |> Http.send BlogPostLoaded


getElmBlogGithubPart2 : Cmd Msg
getElmBlogGithubPart2 =
    "https://absynce.github.io/posts/elm-blog-github-part-2.md"
        |> Http.getString
        |> Http.send BlogPostLoaded


getElmBlogGithubPart3 : Cmd Msg
getElmBlogGithubPart3 =
    "https://absynce.github.io/posts/elm-blog-github-part-3.md"
        |> Http.getString
        |> Http.send BlogPostLoaded



-- VIEW


blogPosts : List BlogPostModel
blogPosts =
    [ elmBlogGithubPart1
    , elmBlogGithubPart2
    , elmBlogGithubPart3
    ]


blogPostsBySlug : Dict String BlogPostModel
blogPostsBySlug =
    blogPosts
        |> List.map (\blogPost -> ( blogPost.slug |> blogPostSlugToString, blogPost ))
        |> Dict.fromList


view : Model -> Html Msg
view model =
    model
        |> pageResponseToContent
        |> render model


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    location
        |> routeFromLocation
        |> asRouteIn initialModel


initialModel : Page
initialModel =
    HomePage <|
        HomeModel
            { contentString = "Loading..."
            , author = ""
            , publishedOn = (Date.fromString "")
            , slug = Slug ""
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


viewHomeLink : Html Msg -> Html Msg
viewHomeLink child =
    a [ onClick <| TransitionTo <| initialModel, href "#" ] [ child ]



--
-- I've been writing software for over 10 years. The beauty, simplicity and usefulness of [Elm](http://elm-lang.org/) is what brought me out of my clamshell and prompted me to write this.


pageResponseToContent : Page -> Html msg
pageResponseToContent page =
    case page of
        HomePage homeModel ->
            Markdown.toHtml [ class "content" ] homeModel.blogPost.contentString

        BlogPostPage blogPostModel ->
            Markdown.toHtml [ class "content" ] blogPostModel.contentString


viewPostLinks : Html Msg
viewPostLinks =
    div [ class "posts" ]
        [ h2 [] [ text "Blog Posts" ]
        , blogPosts
            |> List.map (\post -> li [] [ viewBlogPostLink post ])
            |> ul []
        ]


pageToTitle : Page -> String
pageToTitle page =
    case page of
        HomePage _ ->
            "Home"

        BlogPostPage model ->
            model.title



-- BlogPost Views


viewBlogPostLink : BlogPostModel -> Html Msg
viewBlogPostLink blogPost =
    a
        [ onClick <| TransitionTo <| BlogPostPage blogPost
        , href "#/post"
        ]
        [ text blogPost.title ]


{-| Slug parser based on [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/).
-}
blogPostSlugParser : Url.Parser (Slug -> a) a
blogPostSlugParser =
    Url.custom "SLUG" (Ok << Slug)


blogPostSlugToString : Slug -> String
blogPostSlugToString (Slug slug) =
    slug



-- Route


type Slug
    = Slug String


type Route
    = Home
    | Post Slug


{-| Route parser based on [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm#L26).
-}
route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (Url.s "")
        , Url.map Post (Url.s "post" </> blogPostSlugParser)
        ]


routeFromLocation : Navigation.Location -> Maybe Route
routeFromLocation location =
    location
        |> parseHash route


{-| TODO: Set route based on parameter.
-}
setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute route model =
    case route of
        Just Home ->
            ( model
            , getElmBlogGithubPart1
            )

        Just (Post slug) ->
            -- Should this move to BlogPost.elm (init)?
            let
                slugString =
                    slug |> blogPostSlugToString

                maybeBlogPost =
                    blogPostsBySlug |> Dict.get slugString
            in
                case maybeBlogPost of
                    Just blogPost ->
                        ( BlogPostPage blogPost, blogPost.getContentCmd )

                    Nothing ->
                        Debug.crash "Handle page not found."

        Nothing ->
            ( model
            , getElmBlogGithubPart1
            )


{-| Fluent inverted function for setRoute.

Based on [Updating Nested Records in Elm](https://medium.com/elm-shorts/updating-nested-records-in-elm-15d162e80480) by Wouter In t Velt

-}
asRouteIn : Model -> Maybe Route -> ( Page, Cmd Msg )
asRouteIn =
    flip setRoute
