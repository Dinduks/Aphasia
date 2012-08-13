$(document).ready(function() {
  setIsTyping();
});

// isTyping is used to check if the user focuses
// the repository name check box
function setIsTyping() {
  $.isTyping = false;
  $('.repository-input').bind({
    focus: function() {
      $.isTyping = true;
    },
    mouseout: function() {
      $.isTyping = false;
    }
  })
}
