$(document).ready(function () {
    setIsTyping();
});

// isTyping is used to check if the user focuses
// the repository name check box
function setIsTyping(isTyping) {
    app.isTyping = false;
    $('.repository-input').bind({
        focus: function () {
            app.isTyping = true;
        },
        mouseout: function () {
            app.isTyping = false;
        }
    })
}
