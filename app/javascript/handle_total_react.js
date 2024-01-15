$(document).on('turbo:load', function() {
  var isHoverUserReact = false;

  $(document).on("mouseenter", '.box-detail-total-react', function() {
    isHoverUserReact = true;
    const tagId = $(this).attr('id');
    const parts = tagId.split("-");
    const boxID = parts[parts.length - 1];
    showBoxTotalReact(boxID);
  }).on("mouseleave", '.box-detail-total-react', function() {
    isHoverUserReact = false;
    // Delay hiding .box-react to allow for user interaction
    setTimeout(hideBoxTotalReact, 500);
  })
  
  $(document).on("mouseenter", '.list-user-react', function() {
    isHoverUserReact = true;
  }).on("mouseleave", '.list-user-react', function() {
    isHoverUserReact = false;
    // Delay hiding .box-react to allow for user interaction
    setTimeout(hideBoxTotalReact, 500);
  })
  
  function showBoxTotalReact(boxID) {
    if (isHoverUserReact) {
      $('#list-user-react-' + boxID).addClass('check-user-react');
    }
  }
  
  function hideBoxTotalReact() {
    if (!isHoverUserReact) {
      $('.list-user-react').removeClass('check-user-react');
    }
  }
});

