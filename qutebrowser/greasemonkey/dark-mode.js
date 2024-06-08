// ==UserScript==
// @name        Dark Reader
// @description Toggle dark mode
// @icon        data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMDAgMTAwIj48dGV4dCB5PSIuOWVtIiBmb250LXNpemU9IjkwIj7wn5SFPC90ZXh0Pjwvc3ZnPgo=
// @match       *://*/*
// @exclude     devtools://*
// @version     0.0.1
// @require     https://unpkg.com/darkreader@4.9.58/darkreader.js
// @noframes
// ==/UserScript==

if (document.doctype == null) {
  return;
}

document.onkeyup = function (e) {
  //if (e.ctrlKey && e.shiftKey && e.which == 190) { // Ctrl + Shift + <
  //if (e.metaKey && e.shiftKey && e.which == 68) { // Command + Shift + D
  if (e.metaKey && e.shiftKey && e.which == 66) {
    // Command + Shift + B
    toggle();
  }
};

let state = false;

async function toggle() {
  if (state) {
    enable();
  } else {
    disable();
  }
  state = !state;
}

function disable() {
  DarkReader.disable({
    brightness: 100,
    contrast: 90,
    sepia: 10,
  });
}

function enable() {
  DarkReader.enable({
    brightness: 100,
    contrast: 90,
    sepia: 10,
  });
}
