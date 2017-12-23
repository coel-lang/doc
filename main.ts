import hljs = require("highlight.js");
import $ = require("jquery");

import "./index.css";

hljs.initHighlightingOnLoad()

$('a[href^="http://"], a[href^="https://"]').attr('target', '_blank')

$('a').mouseover(function() {
    $('head').append($('<link/>').attr({ rel: 'prerender', href: $(this).attr('href') }))
})