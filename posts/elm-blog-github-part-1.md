# Learn Elm while writing a blog on GitHub Pages - Part 1 of ...


Share your journey into Elm while learning it by creating a blog in Elm and hosting it for free on GitHub Pages.

## Step 0. - Work through _An Introduction to Elm_

[// NOTE:]: # (Should I just say to read the syntax part since this is so simple?)

If you haven't walked through [An Introduction to Elm](https://guide.elm-lang.org/) do that now. And by "walk through" I mean do the examples and play with the code. It's easy and fun to read. By the end you'll have your environment set up and be ready to start writing your blog in Elm.

## Step 1. - Write some Elm code

Create a `src/Main.elm` file with the following code:

```elm
module Main exposing (main)

import Html exposing (..)


main =
    text "Here's what I learned while exploring Elm..."
```

## Step 2. - Compile your Elm code

```bash
elm make src/Main.elm --output=elm.js
```

The first time you compile you'll get the following:

```nohighlight
Some new packages are needed. Here is the upgrade plan.

  Install:
    elm-lang/core 5.1.1
    elm-lang/html 2.0.0
    elm-lang/virtual-dom 2.0.4

Do you approve of this plan? [Y/n]
```

Press Enter. You should see some packages download and finally:

```nohighlight
Successfully generated elm.js
```

## Step 3. - Add index.html

Fire up your favorite text editor. Add the following to index.html in the root of your project:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>your blog title</title>
    <script src="elm.js"></script>
  </head>
  <body id="page-body">
    <script>
      var app = Elm.Main.fullscreen();
    </script>
  </body>
</html>
```

GitHub Pages looks for `index.html` when serving your site at username.github.io.

This does two important things for Elm:

1. References your compiled Elm app JavaScript output (`elm.js`):
```html
    <script src="elm.js"></script>
```

2. Tells Elm to run your app full screen:
```javascript
    var app = Elm.Main.fullscreen();
```

## Step 4. - Run your app locally

```bash
elm reactor
```

This will start the built-in Elm web server.

<div class="notice">
If you get `elm-reactor: bind: resource busy (Address already in use)` then specify an open port:

```
elm reactor -p 8088
```
</div>

Go to `http://localhost:8000/index.html`.

You should see the text "Here's what I learned while exploring Elm...".

You've written an application! Granted it doesn't do much yet, but you can get pretty far with good content.

Next we're going to work on publishing it.

## Step 5. - Create a GitHub page

[Create a GitHub page](https://pages.github.com/) with your GitHub username: _username.github.io_.

Clone your repository locally.


## Step 6. - Publish it!

Commit your code. You can ignore `elm-stuff`.

<div class="notice">
Make sure you commit `elm.js` too.

<p>
We typically ignore compiled code, but this simplifies the steps for this exercise.
</p>
</div>

Push your commit(s) to GitHub.

Woohoo! You've just hosted an Elm blog on GitHub Pages.

Go to _username.github.io_ and check it out!

## Next steps

In the next post we'll make the site more interesting with a title and content section.
