# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

$ ->
  $('pre code').each (i, el) =>
    # add classes for highlighting and line numbers
    $(el).parent().addClass('prettyprint').addClass('linenums')
    # add class for language highlighting extension
    $(el).attr('class', 'lang-' + $(el).attr('class'))

  # turn on highlighting
  prettyPrint()
