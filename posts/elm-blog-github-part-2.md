# Learn Elm while writing a blog on GitHub Pages - Part 2 of ...

Add title and content areas.

## Step 1 - Try adding an `h1` for the blog title

A naive approach might be to add the `h1` before the content.

```elm
main =
    h1 [] [ text "Elm explorer blog"]
    text "Here's what I learned while exploring Elm..."
```

Let's see what the compiler has to say about it.

Run the following on the command line:

```bash
elm make src/Main.elm --output=elm.js
```

Output from the compiler:
```
-- TYPE MISMATCH -------------------------------------------------- src/Main.elm

Function `h1` is expecting 2 arguments, but was given 4.

7|     h1 [] [ text "Elm explorer blog" ]
8|>    text "Here's what I learned while exploring Elm..."

Maybe you forgot some parentheses? Or a comma?
```

It looks like the compiler thinks we're passing four (4) arguments to the `h1` function but reminds us it expects only two (2).

## Step 2 - Try returning a list

Since functions can only have one return value, let's try returning both of them in a list.

```elm
main =
    [ h1 [] [ text "Elm explorer blog" ]
    , text "Here's what I learned while exploring Elm..."
    ]
```

This time the compiler tells us we're returning an unsupported type of value.

```
-- BAD MAIN TYPE -------------------------------------------------- src/Main.elm

The `main` value has an unsupported type.

6| main =
   ^^^^
I need Html, Svg, or a Program so I have something to render on screen, but you
gave me:

    List (Html msg)
```

Let's not get too caught up on the different types but think back to what did work. We could return some HTML `text`, but we couldn't return a list of HTML "things".

This makes sense if we think about how we write HTML; every element has a single parent:

```html
<html>
   <body>
      <h1>Elm explorer blog</h1>
      Here's what I learned while exploring Elm...
   </body>
</html>
```

In this case both the `h1` and the text "Here's what I..." have a single parent element, `body`. Let's apply this to the Elm application.

## Step 3 - Wrap the elements in the `body`

```elm
main =
    body []
        [ h1 [] [ text "Elm explorer blog" ]
        , text "Here's what I learned while exploring Elm..."
        ]
```

Yay! It compiles! Run it and see your progress come to life.

Next we'll move this into it's own function.

## Step 4 - Move the blog post view into a separate function

Now that we're confident the compiler will have our back let's do a bit of quick refactoring.

[//]: # (Should I mention not to refactor too early?)

Let's move the code to view a blog post into it's own function called `viewBlogPost`:

```elm
main =
    viewBlogPost


viewBlogPost =
    body []
        [ h1 [] [ text "Elm explorer blog" ]
        , text "Here's what I learned while exploring Elm..."
        ]
```

That was easy. It made the code a bit more semantic too.

## Step 5 - Wrap the content with a `div`

Actually, instead of _me_ showing _you_ this code, try it on your own; then show it to me.

<p class="notice">
Chances are good if you make a mistake the compiler will let you know. If you get lost, start back where you knew the code was working and try again.
</p>


[Tweet a link to your commit](https://twitter.com/intent/tweet?url=absynce.github.io&text=Here's+how+I+wrapped+some+content+using+Elm:&hashtags=elm&via=absynce) on GitHub repo with the result!
