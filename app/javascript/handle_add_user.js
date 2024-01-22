$(document).on('turbo:load', function() {
  let boxID = 0;
  $(document).off('click', '.chat-room-add').on('click', '.chat-room-add', function() {
    const tagId = $(this).attr('id');
    const parts = tagId.split("-");
    boxID = parts[parts.length - 1];
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });
    
    $.ajax({
      url: '/add_confirm/' + boxID,
      type: 'GET',
      data: {
        id: boxID,
      },
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      dataType: 'json',
      success: function(response) {
        if(response.success) {
          $('.add-room').addClass('active-display-add-room');
          response.user_chat_rooms.forEach(element => {
            $('#add-room-user-' + element.user_id).removeClass('active-display-add-room')
          });
        }
      },
      error: function(error) {
        console.log(error);
      }
    });
    
  })

  $(document).off('click', '.add-room').on('click', '.add-room', function() {
    const tagUserId = $(this).attr('id');
    const partsUser = tagUserId.split("-");
    const userID = partsUser[partsUser.length - 1];
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });
    
    $.ajax({
      url: '/add_user/' + userID + '/' + boxID,
      type: 'POST',
      data: {
        user_id: userID,
        chat_room_id: boxID,
      },
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      dataType: 'json',
      success: function(response) {
        if(response.success) {
          $('#room-user-' + userID).addClass('active');
          $('#add-room-user-' + userID).removeClass('active-display-add-room');
        }
      },
      error: function(error) {
        console.log(error);
      }
    });
  })
})
