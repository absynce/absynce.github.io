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

import Date exposing (Date)
import Dict exposing (Dict)
import Http
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


type BlogPost
    = None
    | ElmBlogGithubPart0
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


elmBlogGithubPart0 : Model
elmBlogGithubPart0 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2018-01-04" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-0-introduction"
    , title = "elm-blog-github - Part 0 - Introduction"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-0.md"
    , entry = ElmBlogGithubPart0
    }


elmBlogGithubPart1 : Model
elmBlogGithubPart1 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2018-01-13" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-1-host-elm-code-on-github"
    , title = "elm-blog-github - Part 1 - Host Elm code on GitHub"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-1.md"
    , entry = ElmBlogGithubPart1
    }


elmBlogGithubPart2 : Model
elmBlogGithubPart2 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2018-01-20" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-2-add-title-and-content-areas"
    , title = "elm-blog-github - Part 2 - Add title and content areas"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-2.md"
    , entry = ElmBlogGithubPart2
    }


elmBlogGithubPart3 : Model
elmBlogGithubPart3 =
    { contentString = ""
    , author = "Jared M. Smith"
    , publishedOn = Date.fromString "2018-01-27" |> Result.withDefault (Date.fromTime 0)
    , slug = Slug "elm-blog-github-part-3-add-multiple-pages"
    , title = "elm-blog-github - Part 3 - Add multiple pages"
    , getContentUrl = "https://absynce.github.io/posts/elm-blog-github-part-3.md"
    , entry = ElmBlogGithubPart3
    }


posts : List Model
posts =
    [ elmBlogGithubPart0
    , elmBlogGithubPart1
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
