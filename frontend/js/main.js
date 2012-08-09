$(document).ready(function() {
  $('.repository-input').focus();

  $('.timeline-commit a').popover({
    placement: get_popover_placement,
    title: 'Commit name',
    content: 'Date, etc.',
    trigger: 'manual',
  });

  $('.timeline-commit a').click(function() {
    $('.timeline-commit a').popover('show');
    return false;
  });

  $(document).click(function() {
    $('*').popover('hide');
  });

  /**
   * Source: http://stackoverflow.com/a/9261887/604041
   */
  function get_popover_placement(pop, dom_el) {
    var width = window.innerWidth;
    if (width<500) return 'bottom';
    var left_pos = $(dom_el).offset().left;
    if (width - left_pos > 400) return 'right';
    return 'left';
  }
});
