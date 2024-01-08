$(document).on('turbo:load', function() {
  $('.btn-reply').each(function(button) {
      var commentId = $(this).attr('id');
      $('.btn-reply-' + commentId).on('click', function() {
          $('.box-rep-cmt').addClass('box-reply');
          $('.box-edit-cmt').addClass('box-edit');
          $('.box-reply-' + commentId).removeClass('box-reply');
          $('.box-reply-' + commentId).css({
              display: 'flex !important'
          });
          $('#' + commentId).val("");
      });
  });

  $('.btn-edit').each(function(button) {
      var commentId = $(this).attr('id');
      $('.btn-edit-' + commentId).on('click', function() {
          $('.box-edit-cmt').addClass('box-edit');
          $('.box-rep-cmt').addClass('box-reply');
          $('.box-edit-' + commentId).removeClass('box-edit');
          $('.box-edit-' + commentId).css({
              display: 'flex !important'
          });
      });
  });
});
