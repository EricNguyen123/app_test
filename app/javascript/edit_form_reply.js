$(document).on('turbo:load', function() {
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
  
});

