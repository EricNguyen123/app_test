$(document).on('turbo:load', function() {
  $(document).off('click').on('click', '.btn-action', function() {
    let micropostID = $(this).data('micropost-id');
    let emotion = $(this).data('emotion');
    let action = $(this).data('action');
    let userID = $(this).data('user-id');
    let emotionID = $(this).data('emotion-id');
    
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
          id: emotionID,
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
            $('#' + emotion + '-' + micropostID).html(response.html_content);
            $('#box-check-' + micropostID).html(response.html_content);
            $('#total-react-' + micropostID).html(response.html_total_react);
          } else {
            $('#' + emotion + '-' + micropostID).html(response.html_content);
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
