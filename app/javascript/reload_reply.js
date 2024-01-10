function handlePostOrEdit() {
  $('.form-post').each(function(f) {
    var formPostId = $(this).attr('id');
    var parts = formPostId.split("-");
    var fID = parts[parts.length - 1];
    $('#' + formPostId).off("submit").on("submit", function(e) {
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
              $('.reply-comment-micropost_' + res).append(response.html_content);
              $('#' + res_input).val("");
              $('#' + fID).val("");
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

  $('.form-edit').each(function() {
    const formEditId = $(this).attr('id');
    if (formEditId) {
      $('#' + formEditId).off("submit").on("submit", function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
          type: 'PATCH',
          url: $(this).attr('action'),
          data: formData,
          processData: false,
          contentType: false,
          dataType: 'json',
          success: function(response) {
            if (response.success) {
              var res = response.micropost.micropost_id;
              var res_input = response.micropost.id;
              $('#p-micropost_' + res_input).remove()
              $('#micropost_' + res_input).prepend(response.html_content);
              $('.box-edit-cmt').addClass('box-edit');
            } else {
              alert('Error: ' + response.errors.join(', '));
            }
          },
          error: function(xhr, status, error) {
            console.error(status + ': ' + error);
          }
        });
      })
    }
  })

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
}


$(document).on('turbo:load', function() {
  handlePostOrEdit();
});

var observer = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {

      if (mutation.addedNodes.length) {
          mutation.addedNodes.forEach(function(node) {
              if (node.nodeName === 'DIV') {
                handlePostOrEdit()
              }
          });
      }
  });
});

var config = { childList: true, subtree: true };

observer.observe(document.body, config);
