$(document).on('turbo:load', function() {
  let isHovered = false;

  $(document).on("mouseenter", '.button-box-react', function() {
    isHovered = true;
    const boxID = $(this).attr('id');
    setTimeout(showBoxReact(boxID), 1000);
  }).on("mouseleave", '.button-box-react', function() {
    isHovered = false;
    // Delay hiding .box-react to allow for user interaction
    setTimeout(hideBoxReact, 500);
  });

  $(document).on("mouseenter", '.box-react', function() {
    isHovered = true;
  }).on("mouseleave", '.box-react', function() {
    isHovered = false;
    // Delay hiding .box-react to allow for user interaction
    setTimeout(hideBoxReact, 500);
  });

  function showBoxReact(boxID) {
    if (isHovered) {
      $('#box-react-' + boxID).addClass('check-display-react');
    }
  }
  
  function hideBoxReact() {
    if (!isHovered) {
      $('.box-react').removeClass('check-display-react');
    }
  }
});


