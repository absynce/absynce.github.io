# elm-blog-github - Part 3 of 3

## Add multiple pages

Add interaction while improving the architecture.

If you're just arriving, read [the introduction](#!/post/elm-blog-github-part-0-introduction), [part 1](#!/post/elm-blog-github-part-1-host-elm-code-on-github) and [part 2](#!/post/elm-blog-github-part-2-add-title-and-content-areas) first.

### Step 1 - Add The Elm Architecture skeleton

Now that we know how to get something in Elm on a web page hosted on GitHub, let's follow [The Elm Architecture](https://guide.elm-lang.org/architecture/).

In it's simplest form it includes:

- a model,
- a view, and
- an update function.

The model represents our data.

The view defines how we want the model to be displayed. In this case we will output HTML.

The update function explains what should happen when a new message is received requesting some action or change. Example: requesting to view a blog post.

Add the following to your `Main.elm` file:

```elm
main =
    Browser.sandbox
        { init = home
        , update = update
        , view = view
        }


-- Model


type alias Model = { ... }


home = Nothing



-- Update


type Msg = Reset | ...


update msg model =
    case msg of
        Reset ->
            ...



-- View


view model =
    div []
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

This won't compile for a couple reasons. The first is obvious: we haven't defined what happens when we want to show the home page.

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
-- MISSING PATTERNS ----------------------------------------------- src/Main.elm

This `case` does not have branches for all possibilities:

43|>    case msg of
44|>        ShowHomePage ->
45|>            home

Missing possibilities include:

    ShowWhatIMadeWithElmPost

I would have to crash if I saw one of those. Add branches for them!

Hint: If you want to write the code for each branch later, use `Debug.todo` as a
placeholder. Read <https://elm-lang.org/0.19.0/missing-patterns> for more
guidance on this workflow.
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

import Browser
import Html exposing (..)


main =
    Browser.sandbox
        { init = home
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
    div []
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
    div []
        [ h1 [] [ text model.title ]
        , text model.content
        ]
```

However, there's still no interaction. Not for long!

### Step 6 - Add buttons

Add a `div` with two `button` elements to the `view` function. The `onClick` event mimics HTML and expects us to give it a `Msg` to define what it should do.

```elm
view model =
    div []
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

  <pre><code class="lang-elm hljs">import Html.Events exposing (onClick)</code></pre>
</div>

### Step 7 - Review the whole program

Here's your blog post app in all it's glory:

```elm
module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.sandbox
        { init = home
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
    div []
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

- Add [markdown support](https://package.elm-lang.org/packages/elm-explorations/markdown/latest/)
- Improve the UI [with CSS](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#class)
- Create a full-screen app, controlling the page title, with [`Browser.document`](https://package.elm-lang.org/packages/elm/browser/latest/Browser#document)
- Write a new blog post (add interaction `Msg`): `ShowElmMuchLovePost`

If you liked the series share it!
