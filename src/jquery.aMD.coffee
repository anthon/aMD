(($, window, undefined_) ->

  MD = ($el, options) ->

    $styles = $('
      <style id="aMD_styles">
        .aMD_fullscreen_container {
          background: #FFF;
          position: fixed;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          padding: 0px;
          z-index: 999999;
        }
        .aMD_container {
          border: 0px solid #AAA;
          border-width: 1px 1px 0 1px;
        }
        .aMD_iFrame {
          background-color: #FFF;
          width: 50%;
          margin-left: 50%;
          border: none;
        }
        .aMD_iFrame .ref {
          border-bottom: 1px solid blue;
        }
        .aMD_toolbar {
          position: absolute;
          left: 0;
          width: 50%;
          height: auto !important;
          z-index: 1;
        }
        .aMD_toolbar a {
          background-color: #CCC;
        }
        .aMD_toolbar a img {
          display: block;
          opacity: .4;
        }
        .aMD_toolbar a:hover img {
          opacity: 1;
        }
        .aMD_toolbar .left,
        .aMD_toolbar .right {
          position: absolute;
        }
        .aMD_toolbar .left {
          left: 0px;
        }
        .aMD_toolbar .right {
          right: 1px;
        }
        .aMD_container textarea {
          background: #F2F2F2;
          position: absolute;
          top: 0;
          left: 0;
          width: 50%;
          height: 100%;
          margin: 0;
          padding: 42px 12px 12px;
          border: 0px solid #AAA;
          border-right-width: 1px;
          font-family: Courier New, monospace;
          font-size: 13px;
        }
        .aMD_fullscreen_container .aMD_container {
          height: 100% !important;
        }
        .aMD_refSelector {
          display: none;
          position: fixed;
          font-family: monospace;
          font-weight: 100;
        }
        .aMD_refSelector ul {
          list-style-type: none;
        }
        .aMD_refSelector ul li {
          background: white;
          padding: 6px;
          color: gray;
          box-shadow: 0 0 2px 1px rgba(0,0,0,.12);
        }
        .aMD_refSelector ul li.selected {
          background: black;
          color: white;
        }
      </style>
    ')

    defaults =
      imgPath: "../imgs/static/aMD"
      extStyles: ["../css/main.css"]
      icons: true
      helpers: true

    settings = $.extend({}, defaults, options)

    aMD_editor = this
    $textBox = $el
    $container = null
    $markup = null
    $fullscreenContainer = null
    iFrame = null
    $iContents = null
    $refSelector = null
    refRequest = null

    init = ->

      if $('style#aMD_styles').length is 0 then $('head').append($styles)

      textBox_id = $textBox.attr('id')
      $markup = $('<input type="hidden" name="aMD_markup"/>')

      $container = $('<div class="aMD_container"></div>')
      $container.css
        position: 'relative'
        height: $textBox.height()

      $fullscreenContainer = $('<div class="aMD_fullscreen_container"></div>')

      $textBox.wrap $container
      $textBox.before $markup
      
      if settings.helpers
        iFrame = document.createElement("iframe")
        iFrame.className = 'aMD_iFrame'
        iFrame.frameBorder = 0
        iFrame.frameMargin = 0
        iFrame.framePadding = 0
        # iFrame.height = $textBox.css('height')
        iFrame.width = '50%'
        iFrame.id = textBox_id + "-iFrame"
        $(iFrame).load ()->
          fire()
      
      $textBox.after iFrame

      $textBox.on 'change input propertychange', ->
        getText()

      $textBox.on 'keydown', onKeyDown
      $textBox.on 'keyup', onKeyUp

    fire = ()->
      $iContents = $(iFrame).contents()
      buildToolbars()
      buildRefSelector()

      scalePreview()
      setCSS()

      # Fill up
      getText()

    setCSS = ()->
      $iContents.find('body').addClass('aMD-body').css
        'margin': '0px'
        'width': 'auto'
        'height': '100%'
        'padding': $textBox.css('padding')
        'cursor': 'text'
        'overflow': 'auto'
      
      # apply external CSS if enabled
      if settings.extStyles
        i = 0

        while i < settings.extStyles.length
          css = document.createElement("link")
          css.type = "text/css"
          css.rel = "stylesheet"
          css.href = settings.extStyles[i]
          # if $.browser.msie
          #   iDoc.documentElement.firstChild.appendChild css
          # else
          $iContents.find("head").append css
          i++

      getText()

    buildToolbars = ->
      if settings.icons
        $left_toolbar = $('<div class="aMD_toolbar">
            <div class="left">
              <a href="#" class="bold" data-tooltip="Bold"><img src="' + settings.imgPath + '/bold.gif"/>
              </a><a href="#" class="italic" data-tooltip="Italic"><img src="' + settings.imgPath + '/italic.gif"/>
              </a><a href="#" class="linethrough" data-tooltip="Linethrough"><img src="' + settings.imgPath + '/linethrough.gif"/>
              </a><a href="#" class="quote" data-tooltip="Quote"><img src="' + settings.imgPath + '/quote.gif"/>
              </a><a href="#" class="addURL" data-tooltip="Link"><img src="' + settings.imgPath + '/insert_link.gif"/>
              </a><a href="#" class="horizontalRule" data-tooltip="Horisontal Rule"><img src="' + settings.imgPath + '/horizontal_rule.gif"/>
              </a><a href="#" class="list" data-tooltip="List"><img src="' + settings.imgPath + '/list.gif"/></a>
            </div>
            <div class="right">
              <a href="http://daringfireball.net/projects/markdown/basics" target="_blank" data-tooltip="Markdown Help"><img src="' + settings.imgPath + '/md.gif"/>
              </a><a href="#" class="go_fullscreen" data-tooltip="Go Fullscreen"><img src="' + settings.imgPath + '/fullscreen.gif"/></a>
            </div>
          </div>')
      else
        $left_toolbar = $('<div class="aMD_toolbar">
            <div class="left">
              <a href="#" class="bold" data-tooltip="Bold">bold
              </a><a href="#" class="italic" data-tooltip="Italic">italic
              </a><a href="#" class="linethrough" data-tooltip="Linethrough">linethrough
              </a><a href="#" class="quote" data-tooltip="Quote">quote
              </a><a href="#" class="addURL" data-tooltip="Link">link
              </a><a href="#" class="horizontalRule" data-tooltip="Horisontal Rule">hr
              </a><a href="#" class="list" data-tooltip="List">list</a>
            </div>
            <div class="right">
              <a href="http://daringfireball.net/projects/markdown/basics" target="_blank" data-tooltip="Markdown Help">?
              </a><a href="#" class="go_fullscreen" data-tooltip="Go Fullscreen">fullscreen
            </div>
          </div>')

      if $("#aMD_classes").length > 0
        cssURL = $("#aMD_classes").attr("href")
        jQuery.get cssURL, null, (data) ->
          classes = data.match(/\.\w+\s+\{/g)
          selector = "| <select >\t\t\t\t\t\t\t<option value=\"\">\t\t\t\t\t\t\t\t- class -\t\t\t\t\t\t\t</option>"
          i = 0

          while i < classes.length
            classes[i] = classes[i].replace(/[\s\{\.]/g, "")
            selector += "<option value=\"" + classes[i] + "\">"
            selector += toString(classes[i])
            selector += "</option>"
            i++
          selector += "</select>"
          toolbar.append selector

      $(".bold", $left_toolbar).on 'click', ->
        wrapSelection('**')
        false

      $(".italic", $left_toolbar).on 'click', ->
        wrapSelection('_')
        false

      $(".linethrough", $left_toolbar).on 'click', ->
        wrapSelection('~')
        false

      $(".quote", $left_toolbar).on 'click', ->
        prependEveryLineInSelection('> ')
        false

      $(".addURL", $left_toolbar).on 'click', ->
        addURL()
        false
        
      $(".biggerText", $left_toolbar).on 'click', ->
        applyToText "increasefontsize"
        false

      $(".smallerText", $left_toolbar).on 'click', ->
        applyToText "decreasefontsize"
        false

      $(".horizontalRule", $left_toolbar).on 'click', ->
        prependSelection '- - -'
        false

      $(".list", $left_toolbar).on 'click', ->
        prependEveryLineInSelection '- '
        false

      $(".go_fullscreen", $left_toolbar).on 'click', ->
        toggleFullscreen()
        false

      $textBox.focus().before $left_toolbar

    buildRefSelector = ->
      $refSelector = $ '<div class="aMD_refSelector"></div>'
      $textBox.after $refSelector

    wrapSelection = (chars)->
      selection = $textBox.textrange('get')
      char_count = chars.length
      if selection.text.substr(0,char_count) is chars and selection.text.substr(selection.length - char_count) is chars
        mdify selection.text.substr(char_count,selection.length - char_count*2)
      else
        mdify chars+selection.text+chars

    prependSelection = (chars)->
      selection = $textBox.textrange('get')
      char_count = chars.length
      if selection.text.substr(0,char_count) is chars
        mdify selection.text.substr(char_count,selection.length - char_count)
      else
        mdify chars+selection.text

    prependEveryLineInSelection = (chars)->
      selection = $textBox.textrange('get')
      char_count = chars.length
      lines = selection.split '\n'
      for line, i in lines
        if line.substr(0,char_count) is chars
          lines[i] = line.substr(char_count,selection.length - char_count)
        else
          lines[i] = chars+line
      mdify lines.join('\n')

    getCaret = ->
      to_return =
        char: ''
        ref: ''
        x: 0
        y: 0
      if window.getSelection
        el = $textBox[0]
        selection = window.getSelection()
        if selection.rangeCount > 0
          end = el.selectionEnd
          position = window.getCaretCoordinates el, end
          value = el.value
          before = value.substring 0, end
          after = value.substr end
          opening = before.match /@\{([^@\}]+)$/
          if opening
            before_ref = if opening then opening[1] else ''
            ref_array = after.split /\}|@\{[^@\{]+\}/
            reference = before_ref+ref_array[0]
          else
            reference = ''
          to_return =
            char: value.slice end-1, end
            ref: reference
            pos: end
            x: position.left
            y: position.top
      return to_return

    onKeyDown = (e)->
      if e.metaKey
        switch e.keyCode
          when 66
            e.preventDefault()
            wrapSelection '**'
            return false
          when 73
            e.preventDefault()
            wrapSelection '_'
            return false
          when 75
            e.preventDefault()
            addURL()
            return false
          when 13
            e.preventDefault()
            $textBox.closest('form').submit()
            return false
      else if $refSelector.is(':visible')
        switch e.keyCode
          when 40
            $selected = $('li.selected',$refSelector)
            $next = $selected.next 'li'
            if $next.length > 0
              $selected.removeClass 'selected'
              $next.addClass 'selected'
            return false
            break
          when 38
            $selected = $('li.selected',$refSelector)
            $prev = $selected.prev 'li'
            if $prev.length > 0
              $selected.removeClass 'selected'
              $prev.addClass 'selected'
            return false
            break

    onKeyUp = (e)->
      if settings.refEndpoint
        caret = getCaret()
        if $refSelector.is(':visible')
          switch e.keyCode
            when 38, 40
              return false
              break
            when 13
              $selected = $('li.selected',$refSelector)
              ref = $selected.data 'ref'
              tag = '@{'+ref+'}'
              value = $textBox.val().replace '@{'+caret.ref+'}','@{'+caret.ref
              value = value.replace '@{'+caret.ref, tag
              new_caret_pos = value.lastIndexOf(tag)+tag.length
              $textBox.val value
              $textBox.textrange 'setPos',
                start: new_caret_pos
                end: new_caret_pos
              $refSelector.html('').hide()
              getText()
              return false
              break
        if caret.ref is ''
          $refSelector.html('').hide()
        else
          $textBox.trigger 'amd:reference', caret
          container_offs = $('.aMD_container').offset()
          console.log container_offs
          container_y = container_offs.top
          container_x = container_offs.left
          if refRequest then refRequest.abort()
          refRequest = $.ajax
            url: settings.refEndpoint
            method: 'GET'
            data:
              query: caret.ref
            success: (response)->
              if response.length > 0
                html = '<ul>'
                for node, index in response
                  cls = if index is 0 then 'selected' else ''
                  html += '<li class="'+cls+'" data-ref="'+node.id+'-'+node.title+'">'+node.path+'</li>'
                html += '</ul>'
                style =
                  top: caret.y + container_y + 24
                  left: caret.x + container_x
                $refSelector.html(html).css(style).show()
              else
                $refSelector.html('').hide()

    onMouseUp = (e)->

    insertAtCaret = (chars)->
      mdify chars

    addURL = ->
      url = prompt("Enter a URL:", "http://")
      if (url?) and (url isnt "")
        link_text = $textBox.textrange('get')
        replacement = '['+link_text.text+']('+url+')'
        mdify replacement

    mdify = (replacement)->
      $textBox.textrange 'replace', replacement
      getText()

    addClass = (cls) ->
      # to be continued...

    addImage = ->
      imgURL = prompt("Enter a URL:", "http://")
      $textBox.execCommand "InsertImage", false, imgURL  if (imgURL?) and (imgURL isnt "")

    getText = ->
      markup = aMD.makeHtml $textBox.val()
      $textBox.data 'markup', markup
      $markup.val markup
      $iContents.find('body').html markup

    scalePreview = ()->
      iFrame.height = $textBox.css('height')

    toggleFullscreen = ()->
      $container = $('.aMD_container')
      if $container.closest('.aMD_fullscreen_container').length > 0
        $container.unwrap()
      else
        $container.wrap $fullscreenContainer
      scalePreview()

    colourPallete = (dir, width, height) ->
      r = 0
      g = 0
      b = 0
      numList = new Array(6)
      colour = ""
      numList[0] = "00"
      numList[1] = "40"
      numList[2] = "80"
      numList[3] = "BF"
      numList[4] = "FF"
      document.writeln "<table cellspacing=\"1\" cellpadding=\"0\" border=\"0\">"
      r = 0
      while r < 5
        document.writeln "<tr>"  if dir is "h"
        g = 0
        while g < 5
          document.writeln "<tr>"  if dir is "v"
          b = 0
          while b < 5
            colour = String(numList[r]) + String(numList[g]) + String(numList[b])
            document.write "<td bgcolor=\"#" + colour + "\" style=\"width:" + width + "px; height:" + height + "px;\">"
            document.write "<a href=\"#\" onclick=\"setColour('#" + colour + "'); return false;\">k</a>"
            document.writeln "</td>"
            b++
          document.writeln "</tr>"  if dir is "v"
          g++
        document.writeln "</tr>"  if dir is "h"
        r++
      document.writeln "</table>"

    setColour = (colour) ->
      Editor.execCommand "color", false, colour
    
    $.extend aMD_editor,
      reload: ->
        enableDesignMode()

      unload: ->
        disableDesignMode()

    init()


  $.fn.aMD = (options) ->

    @each ->
      $el = $(this)
      md = $el.data("aMD")
      if md
        md.reload()
      else
        md = new MD($el, options)
        $el.data "aMD", md

  # Freebie
  $(document).on 'keydown', 'textarea', (e)->
    $this = $(this)
    if !e.shiftKey and e.keyCode is 9
      e.preventDefault()
      textrange = $this.textrange('get')
      insert = '\t'
      new_caret_pos = textrange.start + insert.length
      $this.textrange('replace',insert)
      $this.textrange 'setcursor',new_caret_pos
      return false

) jQuery, this
