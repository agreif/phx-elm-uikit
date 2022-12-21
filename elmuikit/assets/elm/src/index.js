import { Elm } from './Main.elm';

// const $root = document.createElement('div');
// document.body.appendChild();

// Elm.Main.init({
//   node: $root
// });

const $elmDiv = document.querySelector('#elm-target');
Elm.Main.init({
    node: $elmDiv
});
