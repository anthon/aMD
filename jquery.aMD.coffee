(($, window, undefined_) ->

  $.fn.aMD = (options) ->

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
      </style>
    ')

    MD = ($el, s) ->

      aMD_editor = this
      $textBox = $el
      $container = null
      $markup = null
      $fullscreenContainer = null
      iFrame = null
      $iContents = null

      init = (s) ->

        if $('style#aMD_styles').length is 0 then $('head').append($styles)

        textBox_id = $textBox.attr('id')
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

        $markup = $('<input type="hidden" name="aMD_markup"/>')

        $container = $('<div class="aMD_container"></div>')
        $container.css
          position: 'relative'
          height: $textBox.height()

        $fullscreenContainer = $('<div class="aMD_fullscreen_container"></div>')

        $textBox.wrap $container
        $textBox.before $markup
        $textBox.after iFrame

        $textBox.on 'change input propertychange', ->
          getText()

        $textBox.on 'keydown', (e)->
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
          else
            switch e.keyCode
              when 9
                e.preventDefault()
                prependSelection '\t'
                return false

      fire = ()->
        $iContents = $(iFrame).contents()
        buildToolbars()
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
        $left_toolbar = $('<div class="aMD_toolbar">
            <div class="left">
              <a href="#" class="bold" data-tooltip="Bold"><img src="' + options.imgPath + '/bold.gif"/>
              </a><a href="#" class="italic" data-tooltip="Italic"><img src="' + options.imgPath + '/italic.gif"/>
              </a><a href="#" class="linethrough" data-tooltip="Linethrough"><img src="' + options.imgPath + '/linethrough.gif"/>
              </a><a href="#" class="quote" data-tooltip="Quote"><img src="' + options.imgPath + '/quote.gif"/>
              </a><a href="#" class="addURL" data-tooltip="Link"><img src="' + options.imgPath + '/insert_link.gif"/>
              </a><a href="#" class="horizontalRule" data-tooltip="Horisontal Rule"><img src="' + options.imgPath + '/horizontal_rule.gif"/>
              </a><a href="#" class="list" data-tooltip="List"><img src="' + options.imgPath + '/list.gif"/></a>
            </div>
            <div class="right">
              <a href="http://daringfireball.net/projects/markdown/basics" target="_blank" data-tooltip="Markdown Help"><img src="' + options.imgPath + '/md.gif"/>
              </a><a href="#" class="go_fullscreen" data-tooltip="Go Fullscreen"><img src="' + options.imgPath + '/fullscreen.gif"/></a>
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
          wrapSelection('~~')
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

        $textBox.before $left_toolbar

      wrapSelection = (chars)->
        selection = $textBox.selection 'get'
        char_count = chars.length
        if selection.substr(0,char_count) is chars and selection.substr(selection.length - char_count) is chars
          mdify selection.substr(char_count,selection.length - char_count*2)
        else
          mdify chars+selection+chars

      prependSelection = (chars)->
        selection = $textBox.selection 'get'
        char_count = chars.length
        if selection.substr(0,char_count) is chars
          mdify selection.substr(char_count,selection.length - char_count)
        else
          mdify chars+selection

      prependEveryLineInSelection = (chars)->
        selection = $textBox.selection 'get'
        char_count = chars.length
        lines = selection.split '\n'
        for line, i in lines
          if line.substr(0,char_count) is chars
            lines[i] = line.substr(char_count,selection.length - char_count)
          else
            lines[i] = chars+line
        mdify lines.join('\n')


      insertAtCaret = (chars)->
        mdify chars

      addURL = ->
        url = prompt("Enter a URL:", "http://")
        if (url?) and (url isnt "")
          link_text = $textBox.selection('get')
          replacement = '['+link_text+']('+url+')'
          mdify replacement

      mdify = (replacement)->
        $textBox.selection 'replace',
          text: replacement
          caret: 'after'
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

    defaults =
      imgPath: "../imgs/static/aMD"
      extStyles: ["../css/main.css"]
      lite: false

    settings = $.extend({}, defaults, options)

    @each ->
      $el = $(this)
      md = $el.data("aMD")
      if md
        md.reload()
      else
        md = new MD($el, settings)
        $el.data "aMD", md

) jQuery, this
