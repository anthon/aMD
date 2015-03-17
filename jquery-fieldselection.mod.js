(function() {
  (function() {
    var fieldSelection;
    fieldSelection = {
      getSelection: function() {
        var e;
        e = (this.jquery ? this[0] : this);
        return (("selectionStart" in e && function() {
          var l;
          l = e.selectionEnd - e.selectionStart;
          return {
            start: e.selectionStart,
            end: e.selectionEnd,
            length: l,
            text: e.value.substr(e.selectionStart, l)
          };
        }) || (document.selection && function() {
          var charBefore, r, txt, wt;
          e.focus();
          r = document.selection.createRange();
          if (r == null) {
            return {
              start: 0,
              end: e.value.length,
              length: 0
            };
          }
          txt = r.text;
          txt = txt.replace(/\r*/g, "");
          wt = r.duplicate();
          wt.moveToElementText(e);
          charBefore = -1;
          while (wt.inRange(r)) {
            wt.moveStart("character");
            charBefore++;
          }
          return {
            start: charBefore,
            end: charBefore + txt.length,
            length: txt.length,
            text: txt
          };
        }) || function() {
          return {
            start: 0,
            end: e.value.length,
            length: 0
          };
        })();
      },
      replaceSelection: function() {
        var e, text;
        e = (this.jquery ? this[0] : this);
        text = arguments_[0] || "";
        return (("selectionStart" in e && function() {
          var newPos;
          newPos = e.selectionStart + text.length;
          e.value = e.value.substr(0, e.selectionStart) + text + e.value.substr(e.selectionEnd, e.value.length);
          e.setSelectionRange(newPos, newPos);
          return this;
        }) || (document.selection && function() {
          e.focus();
          document.selection.createRange().text = text;
          return this;
        }) || function() {
          e.value += text;
          return this;
        })();
      }
    };
    return jQuery.each(fieldSelection, function(i) {
      return jQuery.fn[i] = this;
    });
  })();

}).call(this);
