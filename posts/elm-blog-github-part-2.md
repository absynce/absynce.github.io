# Learn Elm while writing a blog on GitHub Pages - Part 2 of ...

Add title and content areas.

## Step 1 - Try adding an `h1` for the blog title

A naive approach might be to just add the `h1` before the content. Let's see what the compiler has to say about it...

```elm
main =
    h1 [] [ text "Elm explorer blog"]
    text "Here's what I learned while exploring Elm..."
```

```
-- TYPE MISMATCH -------------------------------------------------- src/Main.elm

Function `h1` is expecting 3 arguments, but was given 4.

7|     h1 [] [ text "Elm explorer blog" ]
8|>    text "Here's what I learned while exploring Elm..."

Maybe you forgot some parentheses? Or a comma?
```

// TODO: Add explanation.

// THEN: Try putting into an array.
