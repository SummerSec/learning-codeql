<<<<<<< HEAD
version https://git-lfs.github.com/spec/v1
oid sha256:e15452e2eb041ce9bf528e42c84f4ced1b9459a20b1e6163790f282e758cc805
size 427
=======

// Polyfill missing APIs (if we need to), then create the slide deck.
// iOS < 5 needs classList, dataset, and window.matchMedia. Modernizr contains
// the last one.
(function() {
  Modernizr.load({
    test: !!document.body.classList && !!document.body.dataset,
    nope: ['js/polyfills/classList.min.js', 'js/polyfills/dataset.min.js'],
    complete: function() {
      window.slidedeck = new SlideDeck();
    }
  });
})();
>>>>>>> 2922c58a68ebfd227bf7f28067abeae71562dca5
