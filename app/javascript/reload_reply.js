function handlePostOrEdit() {
      $(document).on('submit', '.form-post', function(e){
        const formPostId = $(this).attr('id');
        const parts = formPostId.split("-");
        const fID = parts[parts.length - 1];
        console.log(1)
        e.preventDefault();
        const formData = new FormData(this);
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

      $(document).on('submit', '.form-edit', function(e){
        e.preventDefault();
        console.log($(this).attr('action'))
        const formData = new FormData(this);
        $.ajax({
          type: 'PATCH',
          url: $(this).attr('action'),
          data: formData,
          processData: false,
          contentType: false,
          dataType: 'json',
          success: function(response) {
            console.log(response)
            if (response.success) {
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
   

      $(document).on('click', '.btn-reply', function(){
        const commentId = $(this).attr('id');
        const $form = $(this).closest('.blog-comment');
        $form.find('.box-rep-cmt').addClass('box-reply');
        $form.find('.box-edit-cmt').addClass('box-edit');
        $form.find('.box-reply-' + commentId).removeClass('box-reply');
        $form.find('.box-reply-' + commentId).css({
            display: 'flex !important'
        });
        $form.find('#' + commentId).val("");
      });

      $(document).on('click', '.btn-edit', function() {
        const commentId = $(this).attr('id');
        const $form = $(this).closest('.blog-comment');
        $form.find('.box-rep-cmt').addClass('box-reply');
        $form.find('.box-edit-cmt').addClass('box-edit');
        $form.find('.box-edit-' + commentId).removeClass('box-edit');
        $form.find('.box-edit-' + commentId).css({
          display: 'flex !important'
        });
      });
}

$(document).on('turbo:load', function() {
  handlePostOrEdit();
});
