# phx-elm-uikit

## Elm & Phoenix Setup

```
$ cd <proect-root>

$ npm install -D esbuild-plugin-elm
$ npm install -D elm

$ mkdir assets/elm

$ cd assets/elm

$ elm init

$ cat > src/Main.elm <<EOF
module Main exposing (..)
import Html exposing (text)

name = "John"

main =
  text ("Hello " ++ name ++ "!")
EOF

$ cat > src/index.js <<EOF
import { Elm } from './Main.elm';

const $root = document.createElement('div');
document.body.appendChild($root);

Elm.Main.init({
  node: $root
});
EOF

$ cat > build.js <<EOF
const esbuild = require('esbuild');
const ElmPlugin = require('esbuild-plugin-elm');

esbuild.build({
  entryPoints: ['src/index.js'],
  outfile: '../js/elm.js',
  bundle: true,
  watch: process.argv.includes('--watch'),
  plugins: [
    ElmPlugin({
      debug: true,
      clearOnWatch: true,
    }),
  ],
}).catch(_e => process.exit(1))
EOF

$ cd ..

$ cat >> js/app.js <<EOF
import elm from './elm.js'
EOF

$ cd ..

$ tail config/dev.exs
  watchers: [
    ...
    node: ["./build.js", "--watch", cd: Path.expand("../assets/elm", __DIR__)]
  ]
```

Start the server with `mix phx.server`

You should see "Hello John!" ath the bottom of thhe page

