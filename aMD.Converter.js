'use strict';

(function () {
  var init;
  window.aMD = window.aMD ? window.aMD : {};
  init = function init() {
    aMD.md = new Markdown.Converter();
    // aMD.md = new showdown.Converter()

    // Input fields
    // Name* = _type_(Please enter your name)
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]_([\w]+)_(\[(\d+)?\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)\))?/g, function (whole, label, required, type, _maxlength, maxlength, _placeholder, placeholder) {
        var name, pattern, result, size;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        size = size ? size : 20;
        placeholder = placeholder ? placeholder : '';
        type = type && type !== '_' ? type : 'text';
        pattern = function () {
          switch (type) {
            case 'url':
              return '(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*\/?';
            case 'email':
              return '([a-z0-9_\.-]+)@([a-z0-9_\.-]+)\.([a-z\.]{2,6})';
            default:
              return false;
          }
        }();
        required = required ? 'required' : '';
        result = '<fieldset class="text ' + required + '">';
        result += '<legend>' + label + '</legend>';
        result += '<input';
        if (type) {
          result += ' type="' + type + '"';
        }
        if (pattern) {
          result += ' pattern="' + pattern + '"';
        }
        if (required) {
          result += ' required="' + required + '"';
        }
        if (maxlength) {
          result += ' maxlength="' + maxlength + '"';
        }
        result += ' name="' + name + '" size="' + size + '" placeholder="' + placeholder + '" />';
        result += '</fieldset>';
        return result;
      });
    });
    // Textareas
    // Message* = [___][MAX_SIZE:COLSxROWS](What can we help you with?)
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]\[___\](\[((\d+):)?(\d+)?[x]?(\d+)?\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)\))?/g, function (whole, label, required, _size, _maxlength, maxlength, cols, rows, _placeholder, placeholder) {
        var name, result;
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        cols = cols ? cols : 48;
        rows = rows ? rows : 12;
        placeholder = placeholder ? placeholder : '';
        required = required ? 'required' : '';
        result = '<fieldset class="textarea ' + required + '">';
        result += '<legend>' + label + '</legend>';
        result += '<textarea name="' + name + '"';
        if (required) {
          result += ' required="' + required + '"';
        }
        if (maxlength) {
          result += ' maxlength="' + maxlength + '"';
        }
        result += ' cols="' + cols + '"';
        result += ' rows="' + rows + '"';
        result += ' placeholder="' + placeholder + '"></textarea>';
        result += '</fieldset>';
        return result;
      });
    });
    // Files
    // File* = ^___^[50](image/*)
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]\^(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-\/\*]+))?\^(\[(\d+)\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-\/\*]+)\))?/g, function (whole, label, required, _accept, accept, _size, size, _placeholder, placeholder) {
        var name, result, size_bytes;
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        placeholder = placeholder ? placeholder : '';
        accept = accept ? accept : '';
        required = required ? 'required' : '';
        result = '<fieldset class="file input ' + required + '">';
        result += '<legend>' + label + '</legend>';
        if (size) {
          size_bytes = parseInt(size) * 1024 * 1024;
        }
        if (size_bytes) {
          result += '<input name="MAX_FILE_SIZE" type="hidden" value="' + size_bytes + '">';
        }
        result += '<input';
        if (required) {
          result += ' required="' + required + '"';
        }
        if (size) {
          result += ' data-max-size="' + size + '"';
        }
        result += ' name="' + name + '" type="file" accept="' + accept + '" placeholder="' + placeholder + '">';
        result += '</fieldset>';
        return result;
      });
    });
    // Radio buttons
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]*((\(x?\)[ \t]*[\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)+)/g, function (whole, label, required, radios, last_radio) {
        var checked, cleaned_radios, match, name, radio_id, radio_label, radio_regex, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        required = required ? 'required' : '';
        result = '<fieldset class="radio ' + required + '">';
        result += '<legend>' + label + '</legend>';
        cleaned_radios = radios.trim().replace(/\t/g, ' ');
        radio_regex = /\((x?)\)[ \t]?([\w \t\-]+)/g;
        match = radio_regex.exec(cleaned_radios);
        while (match) {
          radio_label = match[2].trim().replace(/\t/g, ' ');
          radio_id = radio_label.replace(/[ \t]/g, '-').toLowerCase();
          checked = match[1] === 'x' ? 'checked="checked"' : '';
          result += '<input id="' + radio_id + '" type="radio" name="' + name + '" value="' + radio_id + '"' + checked + ' />';
          result += '<label for="' + radio_id + '">' + radio_label + '</label>';
          match = radio_regex.exec(cleaned_radios);
        }
        result += '</fieldset>';
        return result;
      });
    });
    // Checkboxes
    // Legend = [] Label [x] Label
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]*((\[x?\]([ \t]*[\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)?)+)/g, function (whole, label, required, checkboxes, last_checkbox) {
        var checkbox_id, checkbox_label, checkbox_regex, checked, cleaned_checkboxes, match, name, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        required = required ? 'required' : '';
        result = '<fieldset class="checkbox ' + required + '">';
        result += '<legend>' + label + '</legend>';
        cleaned_checkboxes = checkboxes.trim().replace(/\t/g, ' ');
        checkbox_regex = /\[(x?)\]([ \t]?([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)?)/g;
        match = checkbox_regex.exec(cleaned_checkboxes);
        while (match) {
          checkbox_label = match[2].trim().replace(/\t/g, ' ');
          checkbox_id = checkbox_label.replace(/[ \t]/g, '-').toLowerCase();
          checked = match[1] === 'x' ? 'checked="checked"' : '';
          result += '<div>';
          result += '<input id="' + checkbox_id + '_hidden" type="hidden" name="' + name + '" value="" />';
          result += '<input id="' + checkbox_id + '" type="checkbox" name="' + name + '" ' + checked + ' />';
          result += '<label for="' + checkbox_id + '">' + checkbox_label + '</label>';
          result += '</div>';
          match = checkbox_regex.exec(cleaned_checkboxes);
        }
        result += '</fieldset>';
        return result;
      });
    });
    // Select
    // Legend = [] Label [x] Label
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]=[ \t]*(\{(>?([\w \t\-]+)+(\[[\w \t\-]+\])*<?([ \t]?\|[ \t]?)*)+\})+/g, function (whole, label, required, options) {
        var cleaned_options, match, name, option_label, option_regex, raw_value, result, selected, value;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        required = required ? 'required' : '';
        result = '<fieldset class="select ' + required + '">';
        result += '<legend>' + label + '</legend>';
        result += '<select name="' + name + '">';
        cleaned_options = options.trim().replace(/\t/g, ' ');
        option_regex = /(>)?[ \t]*(\w[\w \t\-]+)+(\[[\w \t\-]+\])*(<)?/g;
        match = option_regex.exec(cleaned_options);
        while (match) {
          option_label = match[2].trim().replace(/\t/g, ' ');
          raw_value = match[3] ? match[3] : option_label;
          value = raw_value.replace(/[ \t]/g, '-').toLowerCase();
          selected = match[1] || match[4] ? 'selected' : '';
          result += '<option value="' + value + '" type="option" name="' + name + '" ' + selected + '>' + option_label + '</option>';
          match = option_regex.exec(cleaned_options);
        }
        result += '</select>';
        result += '</fieldset>';
        return result;
      });
    });
    // Submit
    // Submit = [submit]
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)[ \t]*=[ \t]*\[(\w+)\]/g, function (whole, label, type) {
        var name, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        type = type.trim().toLowerCase();
        result = '<button type="' + type + '" name="' + name + '" id="' + name + '">' + label + '</button>';
        return result;
      });
    });
    // Ref
    // @{id-slug}
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/@\{(\d+)(-(.[^\}]+))?\}/g, function (whole, id, has_slug, slug) {
        var result;
        slug = has_slug ? slug : id;
        result = '<a href="' + slug + '" class="ref" data-id="' + id + '">' + slug + '</a>';
        return result;
      });
    });
    // Apply class
    // [.classname] ...
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/^\[\.(.+)\](.+)/gm, function (whole, classname, content) {
        var result;
        result = '<p class="' + classname + '">' + content + '</p>';
        return result;
      });
    });
    // Obfuscated email addresses
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/\[(\w[\w@ \t\-\.]*)\]\((mailto:([\w-\.]+)@((?:[\w-\.]+\.)+)([a-zA-Z]{2,4}))\)/g, function (whole, link, email, name, domain, topdomain) {
        var char, email_array, hashed_email, i, j, l, len, link_array, result;
        email_array = email.split('').reverse();
        email = email_array.join('');
        link_array = link.split('').reverse();
        link = link_array.join('');
        hashed_email = '';
        l = email_array.length;
        for (i = j = 0, len = email_array.length; j < len; i = ++j) {
          char = email_array[i];
          hashed_email += email.charCodeAt(i);
          if (i < l - 1) {
            hashed_email += ',';
          }
        }
        result = '<a href="" style="unicode-bidi:bidi-override;direction:rtl" data-pml="' + hashed_email + '" onmouseenter="(function(e) { _this = e.target; _array = _this.dataset.pml.split(\',\'); var tluser = _array.reduce(function(str,char) { str += String.fromCharCode(parseInt(char)); return str; },\'\'); var result = tluser.split(\'\').reverse().join(\'\'); _this.setAttribute(\'href\',\'mailto:\'+result); })(event)" ontouchstart="(function(e) { _this = e.target; _array = _this.dataset.pml.split(\',\'); var tluser = _array.reduce(function(str,char) { str += String.fromCharCode(parseInt(char)); return str; },\'\'); var result = tluser.split(\'\').reverse().join(\'\'); _this.setAttribute(\'href\',\'mailto:\'+result); })(event)" onmouseleave="(function(e) { _this = e.target; _this.setAttribute(\'href\',\'\'); })(event)">' + link + '</a>';
        return result;
      });
    });
    // Linethrough
    // ~linethrough~
    aMD.md.hooks.chain('preConversion', function (text) {
      return text.replace(/~(.[^~]*)~/g, function (whole, stricken) {
        var result;
        result = '<del>' + stricken + '</del>';
        return result;
      });
    });
    // TODO
    // Extend link with target
    // aMD.md.hooks.chain 'preSpanGamut', (text,runSpanGamut)->
    //   return text.replace /(\[((?:\[[^\]]*\]|[^\[\]])*)\]\([ \t]*()<?((?:\([^)]*\)|[^()\s])*?)>?[ \t]*((['"])(.*?)\6[ \t]*)?\))/g, (wholeMatch, m1, m2, m3, m4, m5, m6, m7, m8, m9)->
    //     if m7 is undefined then m7 = ""
    //     if m9 is undefined then m9 = ""
    //     whole_match = m1
    //     link_text = m2.replace(/:\/\//g, "~P")
    //     link_id = m3.toLowerCase()
    //     url = m4
    //     title = m7

    //     if url is ''
    //         if link_id is ''
    //             link_id = link_text.toLowerCase().replace /[ ]?\n/g, ' '
    //         url = "#" + link_id

    //         if aMD.md.g_urls.get(link_id) isnt undefined
    //             url = aMD.md.g_urls.get(link_id)
    //             if aMD.md.g_titles.get(link_id) isnt undefined
    //                 title = aMD.md.g_titles.get(link_id)
    //         else
    //             if whole_match.search(/\(\s*\)$/m) > -1
    //                 url = ""
    //             else
    //                 return whole_match
    //     url = aMD.md.encodeProblemUrlChars(url)
    //     url = aMD.md.escapeCharacters(url, "*_")
    //     result = "<a href=\"" + url + "\""

    //     if title isnt ""
    //         title = aMD.md.attributeEncode(title)
    //         title = aMD.md.escapeCharacters(title, "*_")
    //         result += " title=\"" + title + "\""

    //     result += ">" + link_text + "</a>"

    //     return result

    // Hard line breaks in <p>
    return aMD.md.hooks.chain('preSpanGamut', function (text, runSpanGamut) {
      return text.replace(/\n/g, '<br>');
    });
  };
  aMD.makeHtml = function (text) {
    return aMD.md.makeHtml(text);
  };
  return init();
})();
