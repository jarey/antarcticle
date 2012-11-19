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

  do ($ = Zepto ? jQuery) ->
    inherit = ['font', 'letter-spacing']

    $.fn.autoGrow = (options) ->

      remove = options in ['remove', no] or !!options?.remove
      comfortZone = options?.comfortZone ? options
      comfortZone = +comfortZone if comfortZone?

      this.each ->
        input = $(this)
        testSubject = input.next().filter('pre.autogrow')

        if testSubject.length and remove # unbind
          input.unbind('input.autogrow')
          testSubject.remove()

        else if testSubject.length # update
          styles = {}
          styles[prop] = input.css(prop) for prop in inherit
          testSubject.css(styles)

          if comfortZone?
            check = ->
              testSubject.text(input.val())
              input.width(testSubject.width() + comfortZone)
            input.unbind('input.autogrow')
            input.bind('input.autogrow', check)
            check()

        else if not remove # bind
          if input.css('min-width') == '0px'
            input.css('min-width', "#{input.width()}px")

          styles =
            position: 'absolute'
            top: -99999
            left: -99999
            width: 'auto'
            visibility: 'hidden'
          styles[prop] = input.css(prop) for prop in inherit

          testSubject = $('<pre class="autogrow"/>').css(styles)
          testSubject.insertAfter(input)

          cz = comfortZone ? 70
          check = ->
            testSubject.text(input.val())
            input.width(testSubject.width() + cz)
          input.bind('input.autogrow', check)
          check()

  # turn on highlighting
  prettyPrint()

  $('input#tags_filter').tagsInput
    'height': 'auto'
    'width': 'auto'
    'defaultText': ''
    #'placeholderColor': 'rgb(153,153,153)'
    'onChange': () ->
      if $('span.tag').size() > 0
        $('#tags_filter_tag').attr('placeholder', '')
      else
        $('#tags_filter_tag').attr('placeholder', 'Tags filter')

        $('#tags_filter_tag').autoGrow({comfortZone: 50})
  placeholder = if $('span.tag').size() > 0 then "" else "Tags filter"
  $('#tags_filter_tag').attr('placeholder', placeholder)

  $('#tags_filter_tag').keyup = ->
    $('div.tagsinput').resizable()
    w = $('#tags_filter_tag').width()
    if w > $('div.tagsinput').width()
      $('div.tagsinput').width(w)

    h = $('#tags_filter_tag').height()
    if h > $('div.tagsinput').height()
      $('div.tagsinput').height(h)
