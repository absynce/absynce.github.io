module Page.Home exposing (Model, init)

import Browser
import Html exposing (..)
import Page.BlogPost as BlogPost
import Page.Errored exposing (PageLoadError)
import Task exposing (Task)


type alias Model =
    { blogPost : BlogPost.Model
    }


init : Model
init =
    Model BlogPost.latest
