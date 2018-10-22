port module Main exposing
    ( Model
    , Msg(..)
    , Page(..)
    , blogPostLoaded
    , getPageBlogPost
    , init
    , initHighlighting
    , main
    , pageToTitle
    , render
    , setRoute
    , subscriptions
    , update
    , updateBlogPostContent
    , updateModelBlogPost
    , view
    , viewBlogPostLink
    , viewHomeLink
    , viewPage
    , viewPageNotFound
    , viewPostLinks
    )

import Browser
import Browser.Navigation
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import List
import Markdown exposing (defaultOptions)
import Page.BlogPost as BlogPost
import Page.Home
import Route exposing (Route)
import Url
import Url.Parser


main : Program () Model Msg
main =
    Browser.application
        --(Route.fromLocation >> SetRoute)
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Page
    = HomePage Page.Home.Model
    | BlogPostPage BlogPost.Model
    | ErrorPage String


type alias Model =
    { page : Page
    , key : Browser.Navigation.Key
    }


init : flags -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        model =
            { page = HomePage Page.Home.init
            , key = key
            }
    in
    model |> routeFromUrl url



-- UPDATE


type Msg
    = BlogPostLoaded (Result Http.Error String)
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        BlogPostLoaded (Ok blogPostContent) ->
            blogPostLoaded model blogPostContent

        BlogPostLoaded (Err err) ->
            let
                errorMessage =
                    "Failed to load blog post"
            in
            ( { model | page = ErrorPage errorMessage }
            , Cmd.none
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Browser.Navigation.load href )

        UrlChanged url ->
            routeFromUrl url model


routeFromUrl url model =
    let
        maybeRoute =
            url
                |> Route.urlHashToUrl
                |> Url.Parser.parse Route.parser
    in
    setRoute maybeRoute model


getPageBlogPost : Page -> Maybe BlogPost.Model
getPageBlogPost page =
    case page of
        HomePage homeModel ->
            Just homeModel.blogPost

        BlogPostPage blogPostModel ->
            Just blogPostModel

        ErrorPage errorMessage ->
            Nothing


updateModelBlogPost : BlogPost.Model -> Page -> Page
updateModelBlogPost newBlogPost model =
    case model of
        HomePage homeModel ->
            HomePage <| Page.Home.Model newBlogPost

        BlogPostPage blogPostModel ->
            BlogPostPage newBlogPost

        ErrorPage errorMessage ->
            model


{-| TODO: Clean this up. Maybe it's time to move to a real SPA pattern.
-}
blogPostLoaded : Model -> String -> ( Model, Cmd Msg )
blogPostLoaded model blogPostContent =
    let
        oldBlogPost =
            model.page
                |> getPageBlogPost
    in
    case oldBlogPost of
        Just blogPost ->
            let
                newBlogPost =
                    blogPost
                        |> updateBlogPostContent blogPostContent

                newPage =
                    model.page
                        |> updateModelBlogPost newBlogPost
            in
            ( { model | page = newPage }, initHighlighting () )

        Nothing ->
            ( { model | page = ErrorPage "Could not update blog post content." }
            , Cmd.none
            )


updateBlogPostContent : String -> BlogPost.Model -> BlogPost.Model
updateBlogPostContent newContent blogPost =
    { blogPost | contentString = newContent }



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "TODO"
    , body =
        [ model.page
            |> viewPage
            |> render
        ]
    }



-- NOTE: Possibly refactor into (Views)/Page.elm like elm-spa-example.


render : Html Msg -> Html Msg
render content =
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
    a
        [ href "#"
        ]
        [ child ]



-- I've been writing software for over 10 years. The beauty, simplicity and usefulness of [Elm](http://elm-lang.org/) is what brought me out of my clamshell and prompted me to write this.


viewPage : Page -> Html Msg
viewPage page =
    case page of
        HomePage homeModel ->
            viewMarkdown homeModel.blogPost.contentString

        BlogPostPage blogPostModel ->
            viewMarkdown blogPostModel.contentString

        ErrorPage errorMessage ->
            page |> viewPageNotFound errorMessage


viewMarkdown : String -> Html Msg
viewMarkdown contentString =
    let
        myOptions =
            { defaultOptions
                | sanitize = False
            }
    in
    Markdown.toHtmlWith myOptions [ class "content" ] contentString


viewPageNotFound : String -> Page -> Html Msg
viewPageNotFound errorMessage page =
    div [ class "content" ]
        [ h2 [] [ text "Error :(" ]
        , p [] [ text errorMessage ]
        , p [] [ viewHomeLink <| text "Go Home" ]
        ]


viewPostLinks : Html Msg
viewPostLinks =
    div [ class "posts" ]
        [ h2 [] [ text "Blog Posts" ]
        , BlogPost.posts
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

        ErrorPage errorMessage ->
            "Page not found"



-- BlogPost Views


viewBlogPostLink : BlogPost.Model -> Html Msg
viewBlogPostLink blogPost =
    a
        -- [ onClick <| TransitionTo <| BlogPostPage blogPost
        [ href <| "#!/post/" ++ (blogPost.slug |> BlogPost.slugToString)
        ]
        [ text blogPost.title ]



-- Route


{-| This is where magic happens for each page.

TODO: Rename it to loadPage?

-}
setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute route model =
    case route of
        Just Route.Home ->
            initHomePage model

        Just (Route.Post slug) ->
            -- Should this move to BlogPost.elm (init)?
            let
                slugString =
                    slug |> BlogPost.slugToString

                maybeBlogPost =
                    BlogPost.postsBySlug |> Dict.get slugString
            in
            case maybeBlogPost of
                Just blogPost ->
                    ( { model | page = BlogPostPage blogPost }
                    , blogPost
                        |> BlogPost.get BlogPostLoaded
                    )

                Nothing ->
                    ( { model | page = ErrorPage <| "Page \"" ++ slugString ++ "\" not found" }
                    , Cmd.none
                    )

        Nothing ->
            initHomePage model


initHomePage model =
    let
        initialHomeModel =
            Page.Home.init
    in
    ( { model | page = HomePage initialHomeModel }
    , initialHomeModel.blogPost
        |> BlogPost.get BlogPostLoaded
    )



-- Ports


port initHighlighting : () -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
