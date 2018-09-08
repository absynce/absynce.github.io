module Page.Home exposing (Model, Msg, init, update, view)

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


view : Model -> Browser.Document Msg
view model =
    Debug.todo "Add Home view."


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
