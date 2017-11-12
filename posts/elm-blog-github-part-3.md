# Learn Elm while writing a blog on GitHub Pages - Part 3 of ...

[//]: # (Using The Elm Architecture)
Add interaction while improving the architecture.

## Step 1 - Add The Elm Architecture skeleton

[//]: # (Revise this...)

Now that we know how to get something in Elm on a web page hosted on GitHub, let's follow [The Elm Architecture](https://guide.elm-lang.org/architecture/).

In it's simplest form it's just:
- a model,
- a view, and
- an update function.

Add the following to your `Main.elm` file below the `main` function:

```elm
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

## Step 2 - Define the model

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

## Step 3 - Define the interactions

Next we'll define the interactions we want in our blog. To continue with the simplicity theme, we'll just have one interaction:

```elm
type Msg = ShowPage Model
```

## Step 4 - Define the `update` function

## Step 5 - Use the model in the `view` function

## Step x

As you can see we've moved `viewBlogPost` to the bottom.
