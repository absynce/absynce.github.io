# elm-blog-github - Part 3 of 3

## Add multiple pages

Add interaction while improving the architecture.

If you're just arriving, read [the introduction](#!/post/elm-blog-github-part-0-introduction), [part 1](#!/post/elm-blog-github-part-1-host-elm-code-on-github) and [part 2](#!/post/elm-blog-github-part-2-add-title-and-content-areas) first.

### Step 1 - Add The Elm Architecture skeleton

[//]: # (Revise this...)

Now that we know how to get something in Elm on a web page hosted on GitHub, let's follow [The Elm Architecture](https://guide.elm-lang.org/architecture/).

In it's simplest form it's just:
- a model,
- a view, and
- an update function.

Add the following to your `Main.elm` file:

```elm
main =
    Html.beginnerProgram
        { model = home
        , update = update
        , view = view
        }


-- Model


type alias Model = { ... }


model = Nothing



-- Update


type Msg = Reset | ...


update msg model =
    case msg of
        Reset ->
            ...



-- View


view model =
    body []
        [ h1 [] [ text "Elm explorer blog" ]
        , text "Here's what I learned while exploring Elm..."
        ]
```

<p class="notice">
    This won't compile yet. We'll fill in the "..." bits soon.
</p>

### Step 2 - Define the model

Now we'll define our model. To keep it simple let's just have a title and some content.

```elm
type alias Model =
    { title : String
    , content : String
    }
```

Let's create a function that returns the model we want for our home page.

```elm
home =
    { title = "Elm explorer blog"
    , content = "Here's what I learned while exploring Elm..."
    }
```

### Step 3 - Define the interactions

Next we'll define the interactions we want in our blog. To continue with the simplicity theme, we'll define each of the pages messages as distinct messages:

```elm
type Msg
    = ShowHomePage
    | ShowWhatIMadeWithElmPost
```

This means we can do two things in our application: show the home page and show the "What You Made with Elm" blog post.

### Step 4 - Define the `update` function

The `update` function defines how to interact with the view and the outside world.

We'll define how to handle our interactions:

```elm
update msg model =
  case msg of
      ShowHomePage ->
          ...
```

This won't compile for a couple reasons. The first is obvious; we haven't defined what happens when we want to show the home page.

Let's fill that in:
```elm
update msg model =
  case msg of
      ShowHomePage ->
          home
```

We've already defined `home` so it seems like this should work. Let's see what the compiler tells us...

```bash
elm make src/Main.elm --output=elm.js
```

Output from the compiler:

```
==================================== ERRORS ====================================

-- MISSING PATTERNS ----------------------------------------------- src/Main.elm

This `case` does not have branches for all possibilities.

47|>    case msg of
48|>        ShowHomePage ->
49|>            home

You need to account for the following values:

    Main.ShowWhatIMadeWithElmPost

Add a branch to cover this pattern!

If you are seeing this error for the first time, check out these hints:
<https://github.com/elm-lang/elm-compiler/blob/0.18.0/hints/missing-patterns.md>
```

Whoa! That's really useful. It tells us we forgot to handle one of the interactions. That means cases _must be exhaustive_ when used this way. It even provides a link explaining why and how to resolve it.

Let's fix it by adding the other interaction to our case expression:

```elm
-- Add the whatIMadeWithElmPost record
whatIMadeWithElmPost =
    { title = "What I Made With Elm"
    , content = "Here's the blog I made in Elm: ..."
    }

-- Other code here


update msg model =
    case msg of
        ShowHomePage ->
            home

        ShowWhatIMadeWithElmPost ->
            whatIMadeWithElmPost

```

Here's what the whole program looks like right now:

```elm
module Main exposing (main)

import Html exposing (..)


main =
    Html.beginnerProgram
        { model = home
        , update = update
        , view = view
        }



type alias Model =
    { title : String
    , content : String
    }


home =
    { title = "Elm explorer blog"
    , content = "Here's what I learned while exploring Elm..."
    }


whatIMadeWithElmPost =
    { title = "What I Made With Elm"
    , content = "Here's the blog I made in Elm: ..."
    }



-- Update


type Msg
    = ShowHomePage
    | ShowWhatIMadeWithElmPost


update msg model =
    case msg of
        ShowHomePage ->
            home

        ShowWhatIMadeWithElmPost ->
            whatIMadeWithElmPost



view model =
    body []
        [ h1 [] [ text "Elm explorer blog" ]
        , text "Here's what I learned while exploring Elm..."
        ]
```

Woohoo! It compiles!!

What happens on the page? Wait, it still just shows the same thing. Let's improve that.

### Step 5 - Use the model in the `view` function

As you can see we've moved `viewBlogPost` to the bottom and renamed it to just `view`. Now we'll set the title and content based on the model instead of hard-coding it.

```elm
view model =
    body []
        [ h1 [] [ text model.title ]
        , text model.content
        ]
```

However, there's still no interaction. Not for long!


### Step 6 - Add buttons

Add a `div` with two `button` elements to the `view` function. The `onClick` event mimics HTML and expects us to give it a `Msg` to define what it should do.

```elm
view model =
    body []
        [ h1 [] [ text model.title ]
        , text model.content
        , div []
            [ button [ onClick ShowHomePage ] [ text "Home" ]
            , button [ onClick ShowWhatIMadeWithElmPost ] [ text "What I Made with Elm" ]
            ]
        ]
```

<div class="notice">
We'll need to import <code>Html.Events</code> at the top before it will compile.

  <pre>
    <code class="lang-elm hljs">import Html.Events exposing (onClick)</code>
  </pre>
</div>

### Step 7 - Review the whole program

Here's your blog post app in all it's glory:

```elm
module Main exposing (main)

import Html exposing (..)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram
        { model = home
        , update = update
        , view = view
        }


type alias Model =
    { title : String
    , content : String
    }


home =
    { title = "Elm explorer blog"
    , content = "Here's what I learned while exploring Elm..."
    }


whatIMadeWithElmPost =
    { title = "What I Made With Elm"
    , content = "Here's the blog I made in Elm: ..."
    }



-- Update


type Msg
    = ShowHomePage
    | ShowWhatIMadeWithElmPost


update msg model =
    case msg of
        ShowHomePage ->
            home

        ShowWhatIMadeWithElmPost ->
            whatIMadeWithElmPost


view model =
    body []
        [ h1 [] [ text model.title ]
        , text model.content
        , div []
            [ button [ onClick ShowHomePage ] [ text "Home" ]
            , button [ onClick ShowWhatIMadeWithElmPost ] [ text "What I Made with Elm" ]
            ]
        ]
```

### Summary

We covered a lot in this post:
- [The Elm Architecture (TEA)](https://guide.elm-lang.org/architecture/)
- `case` expressions
- Model using records

Things we didn't discuss, but secretly used anyway:
- Pure functions
- Union types
- Declarative programming

### Next steps

Explore some more on your own.

Here are a few ideas:
- Add [markdown support](http://package.elm-lang.org/packages/evancz/elm-markdown/latest)
- Improve the UI [with CSS](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Attributes#class)
- Write a new blog post (add interaction `Msg`): `ShowElmMuchLovePost`

If you liked the series share it!
