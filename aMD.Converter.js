// Generated by CoffeeScript 1.10.0
(function() {
  var init;
  window.aMD = window.aMD ? window.aMD : {};
  init = function() {
    aMD.md = new Markdown.Converter();
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]_([\w]+)_(\[(\d+)?\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)\))?/g, function(whole, label, required, type, _maxlength, maxlength, _placeholder, placeholder) {
        var name, pattern, result, size;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        size = size ? size : 20;
        placeholder = placeholder ? placeholder : '';
        type = type && type !== '_' ? type : 'text';
        pattern = (function() {
          switch (type) {
            case 'url':
              return '(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w \.-]*)*\/?';
            case 'email':
              return '([a-z0-9_\.-]+)@([a-z0-9_\.-]+)\.([a-z\.]{2,6})';
            default:
              return false;
          }
        })();
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
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]\[___\](\[((\d+):)?(\d+)?[x]?(\d+)?\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)\))?/g, function(whole, label, required, _size, _maxlength, maxlength, cols, rows, _placeholder, placeholder) {
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
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]\^(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-\/\*]+))?\^(\[(\d+)\])?(\(([\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-\/\*]+)\))?/g, function(whole, label, required, _accept, accept, _size, size, _placeholder, placeholder) {
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
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]*((\(x?\)[ \t]*[\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)+)/g, function(whole, label, required, radios, last_radio) {
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
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]*=[ \t]*((\[x?\]([ \t]*[\wa-zA-Z\u00E0-\u017F\.,'\?\!\/ \t\-]+)?)+)/g, function(whole, label, required, checkboxes, last_checkbox) {
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
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)(\*)?[ \t]=[ \t]*(\{(>?([\w \t\-]+)+(\[[\w \t\-]+\])*<?([ \t]?\|[ \t]?)*)+\})+/g, function(whole, label, required, options) {
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
        result += '</fieldset>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w\/ \t\-\?\(\))]*)[ \t]*=[ \t]*\[(\w+)\]/g, function(whole, label, type) {
        var name, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.trim().replace(/[ \t]/g, '-').toLowerCase();
        type = type.trim().toLowerCase();
        result = '<button type="' + type + '" name="' + name + '" id="' + name + '">' + label + '</button>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/@\{(\d+)(-(.[^\}]+))?\}/g, function(whole, id, has_title, title) {
        var result;
        title = has_title ? title : id;
        result = '<a href="' + id + '" class="ref" data-id="' + id + '">' + title + '</a>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/^\[\.(.+)\](.+)/gm, function(whole, classname, content) {
        var result;
        result = '<p class="' + classname + '">' + content + '</p>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/\[(\w[\w@ \t\-\.]*)\]\((([\w-\.]+)@((?:[\w-\.]+\.)+)([a-zA-Z]{2,4}))\)/g, function(whole, link, email, name, domain, topdomain) {
        var char, hashed_email, hashed_link, i, j, k, l, len, len1, ref, ref1, result;
        hashed_email = '';
        hashed_link = '';
        l = email.length;
        ref = email.split('');
        for (i = j = 0, len = ref.length; j < len; i = ++j) {
          char = ref[i];
          hashed_email += email.charCodeAt(i);
          if (i < l - 1) {
            hashed_email += ',';
          }
        }
        l = link.length;
        ref1 = link.split('');
        for (i = k = 0, len1 = ref1.length; k < len1; i = ++k) {
          char = ref1[i];
          hashed_link += link.charCodeAt(i);
          if (i < l - 1) {
            hashed_link += ',';
          }
        }
        result = '<a data-pml="' + hashed_email + '" data-link="' + hashed_link + '">[protected link]</a>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/~(.[^~]*)~/g, function(whole, stricken) {
        var result;
        result = '<del>' + stricken + '</del>';
        return result;
      });
    });
    return aMD.md.hooks.chain('preSpanGamut', function(text, runSpanGamut) {
      return text.replace(/\n/g, '<br>');
    });
  };
  aMD.makeHtml = function(text) {
    return aMD.md.makeHtml(text);
  };
  return init();
})();
