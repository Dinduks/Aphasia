$(document).ready(function() {
  $.isTyping = false;
  $('.repository-input').bind({
    focus: function() {
      $.isTyping = true;
    },
    mouseout: function() {
      $.isTyping = false;
    }
  })
});
