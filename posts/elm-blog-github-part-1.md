# elm-blog-github - Part 1 of 3

## Host Elm code on GitHub

Share your journey into Elm while learning it by creating a blog in Elm and hosting it for free on GitHub Pages.

If you're just arriving, read [the introduction](#!/post/elm-blog-github-part-0-introduction) first.

### Step 0. - Work through the beginning of _An Introduction to Elm_

If you haven't walked through the beginning of [_An Introduction to Elm_](https://guide.elm-lang.org/) to the ["Core Language" section](https://guide.elm-lang.org/core_language.html) do that now. And by "walk through" I mean do the examples and play with the code. It's easy and fun to read. By the end you'll have your environment set up and be ready to start writing your blog in Elm.

### Step 1. - Write some Elm code

Create a `src/Main.elm` file with the following code:

```elm
module Main exposing (main)

import Html exposing (..)


main =
    text "Here's what I learned while exploring Elm..."
```

### Step 2. - Compile your Elm code

```bash
elm make src/Main.elm --output=elm.js
```

You should see some packages download and finally:

```console
Success! Compiled 1 module.
```

### Step 3. - Add index.html

Fire up your favorite text editor. Add the following to index.html in the root of your project:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Your Blog Title</title>
    <script src="elm.js"></script>
  </head>
  <body id="page-body">
    <div id="elm-app"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById('elm-app')
      });
    </script>
  </body>
</html>
```

GitHub Pages looks for `index.html` when serving your site at username.github.io.

This does two important things for Elm:

1.  References your compiled Elm app JavaScript output (`elm.js`):

```html
    <script src="elm.js"></script>
```

2.  Tells Elm what node to run our app within:

```html
    <div id="elm-app"></div>
    <script>
      var app = Elm.Main.init({
        node: document.getElementById('elm-app')
      });
    </script>
```

### Step 4. - Run your app locally

```bash
elm reactor
```

This will start the built-in Elm web server.

<div class="notice">
  <p>
  If you get `elm: Network.Socket.bind: resource busy (Address in use)` then specify an open port:
  </p>

  <pre><code class="lang-bash">elm reactor --port=8088</code></pre>
</div>

Go to `http://localhost:8000/index.html`.

You should see the text "Here's what I learned while exploring Elm...".

You've written an application! Granted it doesn't do much yet, but you can get pretty far with good content.

Next we're going to work on publishing it.

### Step 5. - Create a GitHub page

[Create a GitHub page](https://pages.github.com/) with your GitHub username: _username.github.io_.

Clone your repository locally.

### Step 6. - Publish it!

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

### Next steps

In [part 2](#!/post/elm-blog-github-part-2-add-title-and-content-areas) we'll make the site more interesting with a title and content section.
