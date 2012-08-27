describe("hideAllPopovers()", function () {
    it("hides the element passed to it", function () {
        $('body').append('<div class="test"></div>');
        hideAllPopovers($('.test'));
        expect($('.test').length).toEqual(0);
    });
});

describe("getShortCommitMessage()", function () {
    it("returns the first line of the commit message, trimed", function () {
        var message,
            shortenedMessage;

        message = "hello \nworld!";
        shortenedMessage = getShortCommitMessage(message);
        expect(shortenedMessage).toEqual("hello");
    });

    it("returns the PR info only", function () {
        var message,
            shortenedMessage;

        message = "Merge pull request #1337 from somerepo/master\n\nAdd some tests ";
        shortenedMessage = getShortCommitMessage(message);
        expect(shortenedMessage).toEqual("Merge PR: Add some tests");
    });
});

describe("loadingAnimation()", function () {
    it("should remove the class", function () {
        $('body').append('<div class="repository-input"></div>');
        loadingAnimation('show');
        loadingAnimation('hide');
        expect($('.repository-input').hasClass('loading-gif')).toBeFalsy();
    });

    it("should add the class", function () {
        $('body').append('<div class="repository-input"></div>');
        loadingAnimation('show');
        expect($('.repository-input').hasClass('loading-gif')).toBeTruthy();
    });

    it("should raise an exception if 'hide' or 'show' weren't passed", function () {
        expect(function () {loadingAnimation('some-word')}).toThrow();
    });
});

