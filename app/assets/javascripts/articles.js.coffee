# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

$ ->
  $('pre > code').each (i, el) =>
    # language specific class
    lang = $(el).attr('class')
    # add classes for highlighting and line numbers
    $(el).parent().addClass('prettyprint').addClass('linenums').addClass("lang-#{lang}")

  # turn on highlighting
  prettyPrint()

  # custom tags input field
  $('#tags_filter').tags_input()
