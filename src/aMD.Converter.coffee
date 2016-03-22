(()->

    window.aMD = if window.aMD then window.aMD else {}

    init = ()->
        aMD.md = new Markdown.Converter()

        # Input fields
        # Name* = _type_(Please enter your name)
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]_([\w]+)_(\[(\d+)?\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)\))?/g, (whole,label,required,type,_maxlength,maxlength,_placeholder,placeholder)->
            label = label.trim().replace /\t/g, ' '
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            size = if size then size else 20
            placeholder = if placeholder then placeholder else ''
            type = if type and type isnt '_' then type else 'text'
            pattern = switch type
                        when 'url'
                            '(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*\/?'
                        when 'email'
                            '([a-z0-9_\.-]+)@([a-z0-9_\.-]+)\.([a-z\.]{2,6})'
                        else
                            false
            required = if required then 'required' else ''
            result = '<fieldset class="text '+required+'">'
            result += '<legend>'+label+'</legend>'
            result += '<input'
            if type then result += ' type="'+type+'"'
            if pattern then result += ' pattern="'+pattern+'"'
            if required then result += ' required="'+required+'"'
            if maxlength then result += ' maxlength="'+maxlength+'"'
            result += ' name="'+name+'" size="'+size+'" placeholder="'+placeholder+'" />'
            result += '</fieldset>'
            return result

        # Textareas
        # Message* = [___][MAX_SIZE:COLSxROWS](What can we help you with?)
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]\[___\](\[((\d+):)?(\d+)?[x]?(\d+)?\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)\))?/g, (whole,label,required,_size,_maxlength,maxlength,cols,rows,_placeholder,placeholder)->
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            cols = if cols then cols else 48
            rows = if rows then rows else 12
            placeholder = if placeholder then placeholder else ''
            required = if required then 'required' else ''
            result = '<fieldset class="textarea '+required+'">'
            result += '<legend>'+label+'</legend>'
            result += '<textarea name="'+name+'"'
            if required then result += ' required="'+required+'"'
            if maxlength then result += ' maxlength="'+maxlength+'"'
            result += ' cols="'+cols+'"'
            result += ' rows="'+rows+'"'
            result += ' placeholder="'+placeholder+'"></textarea>'
            result += '</fieldset>'
            return result

        # Files
        # File* = ^___^[50](image/*)
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]\^(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-\/\*]+))?\^(\[(\d+)\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-\/\*]+)\))?/g, (whole,label,required,_accept,accept,_size,size,_placeholder,placeholder)->
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            placeholder = if placeholder then placeholder else ''
            accept = if accept then accept else ''
            required = if required then 'required' else ''
            result = '<fieldset class="file input '+required+'">'
            result += '<legend>'+label+'</legend>'
            if size
                result += '<input name="MAX_FILE_SIZE" type="hidden" value="'+(parseInt(size)*1024*1024)+'">'
            result += '<input'
            if required then result += ' required="'+required+'"'
            result += ' name="'+name+'" type="file" accept="'+accept+'" placeholder="'+placeholder+'">'
            result += '</fieldset>'
            return result

        # Radio buttons
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]*((\(x?\)[ \t]*[\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)+)/g, (whole,label,required,radios,last_radio)->
            label = label.trim().replace /\t/g, ' '
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            required = if required then 'required' else ''
            result = '<fieldset class="radio '+required+'">'
            result += '<legend>'+label+'</legend>'
            cleaned_radios = radios.trim().replace /\t/g, ' '
            radio_regex = /\((x?)\)[ \t]?([\w \t\-]+)/g
            match = radio_regex.exec cleaned_radios
            while match
              radio_label = match[2].trim().replace /\t/g, ' '
              radio_id = radio_label.replace(/[ \t]/g,'-').toLowerCase()
              checked = if match[1] is 'x' then 'checked="checked"' else ''
              result += '<input id="'+radio_id+'" type="radio" name="'+name+'" value="'+radio_id+'"'+checked+' />'
              result += '<label for="'+radio_id+'">'+radio_label+'</label>'
              match = radio_regex.exec cleaned_radios
            result += '</fieldset>'
            return result

        # Checkboxes
        # Legend = [] Label [x] Label
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]*((\[x?\]([ \t]*[\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)?)+)/g, (whole,label,required,checkboxes,last_checkbox)->
            label = label.trim().replace /\t/g, ' '
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            required = if required then 'required' else ''
            result = '<fieldset class="checkbox '+required+'">'
            result += '<legend>'+label+'</legend>'
            cleaned_checkboxes = checkboxes.trim().replace /\t/g, ' '
            checkbox_regex = /\[(x?)\]([ \t]?([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)?)/g
            match = checkbox_regex.exec cleaned_checkboxes
            while match
              checkbox_label = match[2].trim().replace /\t/g, ' '
              checkbox_id = checkbox_label.replace(/[ \t]/g,'-').toLowerCase()
              checked = if match[1] is 'x' then 'checked="checked"' else ''
              result += '<div>'
              result += '<input id="'+checkbox_id+'_hidden" type="hidden" name="'+name+'" value="0" />'
              result += '<input id="'+checkbox_id+'" type="checkbox" name="'+name+'" '+checked+' />'
              result += '<label for="'+checkbox_id+'">'+checkbox_label+'</label>'
              result += '</div>'
              match = checkbox_regex.exec cleaned_checkboxes
            result += '</fieldset>'
            return result

        # Select
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]=[ \t]*(\{(>?([\w \t\-]+)+(\[[\w \t\-]+\])*<?([ \t]?\|[ \t]?)*)+\})+/g, (whole,label,required,options)->
            label = label.trim().replace /\t/g, ' '
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            required = if required then 'required' else ''
            result = '<fieldset class="select '+required+'">'
            result += '<legend>'+label+'</legend>'
            result += '<select name="'+name+'">'
            cleaned_options = options.trim().replace /\t/g, ' '
            option_regex = /(>)?[ \t]*(\w[\w \t\-]+)+(\[[\w \t\-]+\])*(<)?/g
            match = option_regex.exec cleaned_options
            while match
              option_label = match[2].trim().replace /\t/g, ' '
              raw_value = if match[3] then match[3] else option_label
              value =  raw_value.replace(/[ \t]/g,'-').toLowerCase()
              selected = if match[1] or match[4] then 'selected' else ''
              result += '<option value="'+value+'" type="option" name="'+name+'" '+selected+'>'+option_label+'</option>'
              match = option_regex.exec cleaned_options
            result += '</fieldset>'
            return result

        # Submit
        # Submit = [submit]
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /(\w[\w\/ \t\-\?\(\))]*)[ \t]*=[ \t]*\[(\w+)\]/g, (whole,label,type)->
            label = label.trim().replace /\t/g, ' '
            name = label.trim().replace(/[ \t]/g,'-').toLowerCase()
            type = type.trim().toLowerCase()
            result = '<button type="'+type+'" name="'+name+'" id="'+name+'">'+label+'</button>'
            return result

        # Ref
        # @{id-title}
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /@\{(\d+)-(.[^\}]+)\}/g, (whole,id,title)->
            result = '<a href="'+id+'" class="ref" data-id="'+id+'">'+title+'</a>'
            return result

        # Obfuscated email addresses
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /\[(\w[\w@ \t\-\.]*)\]\((([\w-\.]+)@((?:[\w-\.]+\.)+)([a-zA-Z]{2,4}))\)/g, (whole,link,email,name,domain,topdomain)->
            hashed_email = ''
            hashed_link = ''
            l = email.length
            for char,i in email.split('')
              hashed_email += email.charCodeAt i
              if i < l-1 then hashed_email += ','
            l = link.length
            for char,i in link.split('')
              hashed_link += link.charCodeAt i
              if i < l-1 then hashed_link += ','
            result = '<a data-pml="'+hashed_email+'" data-link="'+hashed_link+'">[protected link]</a>'
            return result

        # Linethrough
        # ~linethrough~
        aMD.md.hooks.chain 'preConversion', (text)->
          return text.replace /~(.[^~]*)~/g, (whole,stricken)->
            result = '<del>'+stricken+'</del>'
            return result

        # TODO
        # Extend link with target
        # aMD.md.hooks.chain 'preSpanGamut', (text,runSpanGamut)->
        #   return text.replace /(\[((?:\[[^\]]*\]|[^\[\]])*)\]\([ \t]*()<?((?:\([^)]*\)|[^()\s])*?)>?[ \t]*((['"])(.*?)\6[ \t]*)?\))/g, (wholeMatch, m1, m2, m3, m4, m5, m6, m7, m8, m9)->
        #     if m7 is undefined then m7 = ""
        #     if m9 is undefined then m9 = ""
        #     whole_match = m1
        #     link_text = m2.replace(/:\/\//g, "~P")
        #     link_id = m3.toLowerCase()
        #     url = m4
        #     title = m7

        #     if url is ''
        #         if link_id is ''
        #             link_id = link_text.toLowerCase().replace /[ ]?\n/g, ' '
        #         url = "#" + link_id

        #         if aMD.md.g_urls.get(link_id) isnt undefined
        #             url = aMD.md.g_urls.get(link_id)
        #             if aMD.md.g_titles.get(link_id) isnt undefined
        #                 title = aMD.md.g_titles.get(link_id)
        #         else
        #             if whole_match.search(/\(\s*\)$/m) > -1
        #                 url = ""
        #             else
        #                 return whole_match
        #     url = aMD.md.encodeProblemUrlChars(url)
        #     url = aMD.md.escapeCharacters(url, "*_")
        #     result = "<a href=\"" + url + "\""

        #     if title isnt ""
        #         title = aMD.md.attributeEncode(title)
        #         title = aMD.md.escapeCharacters(title, "*_")
        #         result += " title=\"" + title + "\""

        #     result += ">" + link_text + "</a>"

        #     return result

        # Hard line breaks in <p>
        aMD.md.hooks.chain 'preSpanGamut', (text,runSpanGamut)->
          return text.replace /\n/g, '<br>'

    aMD.makeHtml = (text)->
        return aMD.md.makeHtml(text)

    init()

)()