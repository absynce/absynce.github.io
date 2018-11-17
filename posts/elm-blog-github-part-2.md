# elm-blog-github - Part 2 of 3

## Add title and content areas

If you're just arriving, read [the introduction](#!/post/elm-blog-github-part-0-introduction) and [part 1](#!/post/elm-blog-github-part-1-host-elm-code-on-github) first.

### Step 1 - Try adding an `h1` for the blog title

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
-- TOO MANY ARGS -------------------------------------------------- src/Main.elm

The `h1` function expects 2 arguments, but it got 4 instead.

 7|>    h1 []
 8|         [ text "Elm explorer blog" ]
 9|         text
10|         "Here's what I learned while exploring Elm..."

Are there any missing commas? Or missing parentheses?
```

It looks like the compiler thinks we're passing four (4) arguments to the `h1` function but reminds us it expects only two (2).

### Step 2 - Try returning a list

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

I cannot handle this type of `main` value:

6| main =
   ^^^^
The type of `main` value I am seeing is:

    List (Html msg)

I only know how to handle Html, Svg, and Programs though. Modify `main` to be
one of those types of values!
```

Let's not get too caught up on the different types but think back to what did work. We could return some HTML `text`, but we couldn't return a list of HTML "things".

This makes sense if we think about how we write HTML; every element has a single parent:

```html
<html>
   <body>
      <div>
         <h1>Elm explorer blog</h1>
         Here's what I learned while exploring Elm...
      </div>
   </body>
</html>
```

In this case both the `h1` and the text "Here's what I..." have a single parent element, `div`. Let's apply this to the Elm application.

### Step 3 - Wrap the elements in the `div`

```elm
main =
    div []
        [ h1 [] [ text "Elm explorer blog" ]
        , text "Here's what I learned while exploring Elm..."
        ]
```

Yay! It compiles! Run it and see your progress come to life.

Next we'll move this into it's own function.

### Step 4 - Move the blog post view into a separate function

Now that we're confident the compiler will have our back let's do a bit of quick refactoring.

Let's move the code to view a blog post into it's own function called `viewBlogPost`:

```elm
main =
    viewBlogPost


viewBlogPost =
    div []
        [ h1 [] [ text "Elm explorer blog" ]
        , text "Here's what I learned while exploring Elm..."
        ]
```

That was easy. It made the code a bit more semantic too.

### Step 5 - Wrap the content with an `article` tag

Actually, instead of _me_ showing _you_ this code, try it on your own; then show it to me.

<p class="notice">
Chances are good if you make a mistake the compiler will let you know. If you get lost, start back where you knew the code was working and try again.
</p>

[Tweet a link to your commit](https://twitter.com/intent/tweet?url=absynce.github.io&text=Here's+how+I+wrapped+some+content+using+Elm:&hashtags=elm&via=absynce) on GitHub repo with the result!

### Next steps

Make the blog interactive with multiple pages in [part 3](#!/post/elm-blog-github-part-3-add-multiple-pages).
