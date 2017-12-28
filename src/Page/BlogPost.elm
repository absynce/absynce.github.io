module Page.BlogPost
    exposing
        ( BlogPost(..)
        , Model
        , Msg(..)
        , Slug(..)
        , get
        , latest
        , posts
        , postsBySlug
        , slugParser
        , slugToString
        )

--, Msg, view, update)

import Date exposing (Date)
import Dict exposing (Dict)
import Http
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


type BlogPost
    = None
    | ElmBlogGithubPart1
    | ElmBlogGithubPart2
    | ElmBlogGithubPart3


type Slug
    = Slug String


type alias Model =
    { contentString : String
    , author : String
    , publishedOn : Date
    , slug : Slug
    , title : String
    , getContentUrl : String
    , entry : BlogPost
    }


elmBlogGithubPart1 : Model
elmBlogGithubPart1 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2017-12-13" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-1-host-elm-code-on-github"
    , title = "elm-blog-github - Part 1 - Host Elm code on GitHub"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-1.md"
    , entry = ElmBlogGithubPart1
    }


elmBlogGithubPart2 : Model
elmBlogGithubPart2 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2017-12-20" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-2-add-title-and-content-areas"
    , title = "elm-blog-github - Part 2 - Add title and content areas"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-2.md"
    , entry = ElmBlogGithubPart2
    }


elmBlogGithubPart3 : Model
elmBlogGithubPart3 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2017-12-27" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-3-add-multiple-pages"
    , title = "elm-blog-github - Part 3 - Add multiple pages"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-3.md"
    , entry = ElmBlogGithubPart3
    }


posts : List Model
posts =
    [ elmBlogGithubPart1
    , elmBlogGithubPart2
    , elmBlogGithubPart3
    ]


postsBySlug : Dict String Model
postsBySlug =
    posts
        |> List.map (\blogPost -> ( blogPost.slug |> slugToString, blogPost ))
        |> Dict.fromList


latest : Model
latest =
    posts
        |> List.sortBy (\post -> post.publishedOn |> Date.toTime)
        |> List.head
        |> Maybe.withDefault elmBlogGithubPart1


type Msg
    = BlogPostLoaded (Result Http.Error String)



-- HTTP


get : (Result Http.Error String -> msg) -> Model -> Cmd msg
get toMsg model =
    model.getContentUrl
        |> Http.getString
        |> Http.send toMsg



-- Routing


{-| Slug parser based on [elm-spa-example](https://github.com/rtfeldman/elm-spa-example/).
-}
slugParser : Url.Parser (Slug -> a) a
slugParser =
    Url.custom "SLUG" (Ok << Slug)


slugToString : Slug -> String
slugToString (Slug slug) =
    slug