$(document).on('turbo:load', function() {
  $('.form-post').each(function(f) {
    var formPostId = $(this).attr('id');
    var parts = formPostId.split("-");
    var fID = parts[parts.length - 1];
    $('#' + formPostId).off("submit").on("submit", function(e) {
      console.log('#' + formPostId)
      e.preventDefault();
      var formData = new FormData(this);
      $.ajax({
          type: 'POST',
          url: $(this).attr('action'),
          data: formData,
          processData: false,
          contentType: false,
          dataType: 'json',
          success: function(response) {
            if (response.success) {
              var res = response.micropost.micropost_id;
              var res_input = response.micropost.id;
              if ($('.reply-comment-micropost_' + res).length <= 0) {
                $('.reply-list-micropost_' + fID).prepend('<div class="reply-comment reply-comment-micropost_' + fID + '"></div>');
              }
              $('.reply-comment-micropost_' + res).html(response.html_content);
              $('#' + res_input).val("");
              $('#' + fID).val("");
              window.location.reload();
            } else {
              alert('Error: ' + response.errors.join(', '));
            }
          },
          error: function(xhr, status, error) {
            console.error(status + ': ' + error);
          }
      });
      
    });
  })
});
