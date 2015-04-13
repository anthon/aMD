// Generated by CoffeeScript 1.8.0
(function() {
  var init;
  window.aMD = window.aMD ? window.aMD : {};
  init = function() {
    aMD.md = new Markdown.Converter();
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w \t\-]*)(\*)?[ \t]*=[ \t]___(\[(\d+)\])?(\(([\w\.\? \t\-]+)\))?/g, function(whole, label, required, _size, size, _placeholder, placeholder) {
        var name, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.replace(/[ \t]/g, '-').toLowerCase();
        size = size ? size : 20;
        placeholder = placeholder ? placeholder : '';
        required = required ? 'required' : '';
        result = '<fieldset class="' + required + '">';
        result += '<legend>' + label + '</legend>';
        result += '<input type="text" name="' + name + '" size="' + size + '" placeholder="' + placeholder + '" />';
        result += '</fieldset>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w \t\-]*)(\*)?[ \t]*=[ \t]\[___\](\[(\d+)?[x]?(\d+)?\])?(\(([\w\.\? \t\-]+)\))?/g, function(whole, label, required, _size, cols, rows, _placeholder, placeholder) {
        var name, result;
        name = label.replace(/[ \t]/g, '-').toLowerCase();
        cols = cols ? cols : 48;
        rows = rows ? rows : 12;
        placeholder = placeholder ? placeholder : '';
        required = required ? 'required' : '';
        result = '<fieldset class="' + required + '">';
        result += '<legend>' + label + '</legend>';
        result += '<textarea name="' + name + '" cols="' + cols + '" rows="' + rows + '" placeholder="' + placeholder + '"></textarea>';
        result += '</fieldset>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w \t\-]*)(\*)?[ \t]*=[ \t]*((\(x?\)[ \t]*[\w \t\-]+)+)/g, function(whole, label, required, radios, last_radio) {
        var checked, cleaned_radios, match, name, radio_id, radio_label, radio_regex, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.replace(/[ \t]/g, '-').toLowerCase();
        required = required ? 'required' : '';
        result = '<fieldset class="' + required + '">';
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
      return text.replace(/(\w[\w \t\-]*)(\*)?[ \t]*=[ \t]*((\[x?\][ \t]*[\w \t\-]+)+)/g, function(whole, label, required, checkboxes, last_checkbox) {
        var checkbox_id, checkbox_label, checkbox_regex, checked, cleaned_checkboxes, match, name, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.replace(/[ \t]/g, '-').toLowerCase();
        required = required ? 'required' : '';
        result = '<fieldset class="' + required + '">';
        result += '<legend>' + label + '</legend>';
        cleaned_checkboxes = checkboxes.trim().replace(/\t/g, ' ');
        checkbox_regex = /\[(x?)\][ \t]?([\w \t\-]+)/g;
        match = checkbox_regex.exec(cleaned_checkboxes);
        while (match) {
          checkbox_label = match[2].trim().replace(/\t/g, ' ');
          checkbox_id = checkbox_label.replace(/[ \t]/g, '-').toLowerCase();
          checked = match[1] === 'x' ? 'checked="checked"' : '';
          result += '<input id="' + checkbox_id + '" type="checkbox" name="' + name + '" ' + checked + ' />';
          result += '<label for="' + checkbox_id + '">' + checkbox_label + '</label>';
          match = checkbox_regex.exec(cleaned_checkboxes);
        }
        result += '</fieldset>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/(\w[\w \t\-]*)(\*)?[ \t]=[ \t]*(\{(>?([\w \t\-]+)+(\[[\w \t\-]+\])*<?([ \t]?\|[ \t]?)*)+\})+/g, function(whole, label, required, options) {
        var cleaned_options, match, name, option_label, option_regex, raw_value, result, selected, value;
        label = label.trim().replace(/\t/g, ' ');
        name = label.replace(/[ \t]/g, '-').toLowerCase();
        required = required ? 'required' : '';
        result = '<fieldset class="' + required + '">';
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
      return text.replace(/(\w[\w \t\-]*)[ \t]*=[ \t]*\[(\w+)\]/g, function(whole, label, type) {
        var name, result;
        label = label.trim().replace(/\t/g, ' ');
        name = label.replace(/[ \t]/g, '-').toLowerCase();
        type = type.trim().toLowerCase();
        result = '<button type="' + type + '" name="' + name + '" id="' + name + '">' + label + '</button>';
        return result;
      });
    });
    aMD.md.hooks.chain('preConversion', function(text) {
      return text.replace(/\[(\w[\w@ \t\-\.]*)\]\((([\w-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4}))\)/g, function(whole, link, email, name, domain, topdomain) {
        var char, hashed_email, hashed_link, i, l, result, _i, _j, _len, _len1, _ref, _ref1;
        hashed_email = '';
        hashed_link = '';
        l = email.length;
        _ref = email.split('');
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          char = _ref[i];
          hashed_email += email.charCodeAt(i);
          if (i < l - 1) {
            hashed_email += ',';
          }
        }
        l = link.length;
        _ref1 = link.split('');
        for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
          char = _ref1[i];
          hashed_link += link.charCodeAt(i);
          if (i < l - 1) {
            hashed_link += ',';
          }
        }
        result = '<a data-pml="' + hashed_email + '" data-link="' + hashed_link + '">[protected link]</a>';
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
