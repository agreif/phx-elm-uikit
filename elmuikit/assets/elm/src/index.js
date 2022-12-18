import { Elm } from './Main.elm';

const $root = document.createElement('div');
document.body.appendChild($root);

Elm.Main.init({
    node: $root,
    //flags: null,
    flags: "http://localhost:4000/profile"
});
