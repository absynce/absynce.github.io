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
import Page.BlogPost as BlogPost
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


type alias HomeModel =
    { blogPost : BlogPost.Model
    }


type Page
    = HomePage HomeModel
    | BlogPostPage BlogPost.Model
    | ErrorPage String


type alias Model =
    Page


initialModel : Page
initialModel =
    HomePage <|
        HomeModel
            { contentString = "Loading..."
            , author = ""
            , publishedOn = Date.fromTime 0
            , slug = BlogPost.Slug ""
            , title = "Loading..."
            , getContentUrl = ""
            , entry = BlogPost.None
            }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    location
        |> routeFromLocation
        |> asRouteIn initialModel



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
            -- ( BlogPostPage blogPostModel, blogPostModel.getContentCmd )
            model
                |> (setRoute <| Just <| Post blogPostModel.slug)

        SetRoute maybeRoute ->
            model
                |> setRoute maybeRoute

        TransitionTo (ErrorPage errorMessage) ->
            ( ErrorPage errorMessage, Cmd.none )


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
            HomePage <| HomeModel newBlogPost

        BlogPostPage blogPostModel ->
            BlogPostPage newBlogPost

        ErrorPage errorMessage ->
            model


{-| TODO: Clean this up. Maybe it's time to move to a real SPA pattern.
-}
blogPostLoaded : Model -> Result Http.Error String -> ( Model, Cmd Msg )
blogPostLoaded model blogPostResult =
    case blogPostResult of
        Ok blogPostContent ->
            let
                oldBlogPost =
                    model
                        |> getPageBlogPost
            in
                case oldBlogPost of
                    Just blogPost ->
                        let
                            newBlogPost =
                                blogPost
                                    |> updateBlogPostContent blogPostContent

                            newModel =
                                model
                                    |> updateModelBlogPost newBlogPost
                        in
                            ( newModel, initHighlighting () )

                    Nothing ->
                        ( ErrorPage "Could not update blog post content.", Cmd.none )

        Err err ->
            let
                errorMessage =
                    err
                        |> toString
                        |> (++) "Failed to load blog post: "
            in
                ( ErrorPage errorMessage, Cmd.none )


updateBlogPostContent : String -> BlogPost.Model -> BlogPost.Model
updateBlogPostContent newContent blogPost =
    { blogPost | contentString = newContent }



-- VIEW


view : Model -> Html Msg
view model =
    model
        |> viewPage
        |> render model



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



-- I've been writing software for over 10 years. The beauty, simplicity and usefulness of [Elm](http://elm-lang.org/) is what brought me out of my clamshell and prompted me to write this.


viewPage : Page -> Html Msg
viewPage page =
    case page of
        HomePage homeModel ->
            Markdown.toHtml [ class "content" ] homeModel.blogPost.contentString

        BlogPostPage blogPostModel ->
            Markdown.toHtml [ class "content" ] blogPostModel.contentString

        ErrorPage errorMessage ->
            page |> viewPageNotFound errorMessage


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
        [ onClick <| TransitionTo <| BlogPostPage blogPost
        , href <| "#/post/" ++ (blogPost.slug |> BlogPost.slugToString)
        ]
        [ text blogPost.title ]



-- Route


type Route
    = Home
    | Post BlogPost.Slug


{-| Route parser based on [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Route.elm#L26).
-}
route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (Url.s "")
        , Url.map Post (Url.s "post" </> BlogPost.slugParser)
        ]


routeFromLocation : Navigation.Location -> Maybe Route
routeFromLocation location =
    location
        |> parseHash route


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute route model =
    case route of
        Just Home ->
            ( initialModel
            , BlogPost.latest |> BlogPost.get BlogPostLoaded
            )

        Just (Post slug) ->
            -- Should this move to BlogPost.elm (init)?
            let
                slugString =
                    slug |> BlogPost.slugToString

                maybeBlogPost =
                    BlogPost.postsBySlug |> Dict.get slugString
            in
                case maybeBlogPost of
                    Just blogPost ->
                        ( BlogPostPage blogPost
                        , blogPost
                            |> BlogPost.get BlogPostLoaded
                        )

                    Nothing ->
                        ( ErrorPage <| "Page \"" ++ slugString ++ "\" not found"
                        , Cmd.none
                        )

        Nothing ->
            ( initialModel
            , BlogPost.latest |> BlogPost.get BlogPostLoaded
            )


{-| Fluent inverted function for setRoute.

Based on [Updating Nested Records in Elm](https://medium.com/elm-shorts/updating-nested-records-in-elm-15d162e80480) by Wouter In t Velt

-}
asRouteIn : Model -> Maybe Route -> ( Page, Cmd Msg )
asRouteIn =
    flip setRoute



-- Ports


port initHighlighting : () -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
