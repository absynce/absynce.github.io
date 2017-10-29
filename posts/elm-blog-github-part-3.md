# Learn Elm while writing a blog on GitHub Pages - Part 2 of ...

[//]: # (Using The Elm Architecture)
Add interaction while improving the architecture.

## Step 1 - Add The Elm Architecture skeleton

[//]: # (Revise this...)

Now that we know how to get something in Elm on a web page hosted on GitHub, let's follow [The Elm Architecture](https://guide.elm-lang.org/architecture/).

Add the following to your `Main.elm` file:

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
    text "Here's what I learned while learning Elm..."
```
