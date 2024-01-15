$(document).on('turbo:load', function() {
  $(document).off('click', '.btn-action').on('click', '.btn-action', function() {
    let tag = $(this).closest('.button-box-react');
    const tagId = tag.attr('id');
    const parts = tagId.split("-");
    const micropostID = parts[parts.length - 1];
    let emotion = $(this).data('emotion');
    let action = $(this).data('action');
    let userID = $(this).data('user-id');

    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });
    
    $.ajax({
      url: action === 'create' ? '/reacts' : '/reacts/' + micropostID,
      type: action === 'create' ? 'POST' : 'DELETE',
      data: {
        react: {
          micropost_id: micropostID,
          action: emotion,
          user_id: userID
        }
      },
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      dataType: 'json',
      success: function(response) {
        if(response.success) {
          if(action === 'create') {
            $('#box-check-' + micropostID).html(response.html_content);
            $('#total-react-' + micropostID).html(response.html_total_react);
          } else {
            $('#box-check-' + micropostID).html(response.html_cancel);
            $('#total-react-' + micropostID).html(response.html_total_react);
          }
        }
      },
      error: function(error) {
        console.log(error);
      }
    });
    
  })
});
