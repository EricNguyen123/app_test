function handle_msg_change() {
  let user = $('#chatroom_container').data('user');

  if (user) {
    $('.msg-li-' + user).addClass('active-msg-current-user');
    $('.cont-' + user).addClass('active-msg-box');
    $('.message-delete-' + user).addClass('active-display-del');
    $('.btn-edit-msg-' + user).addClass('active-display-del');
  }
}

$(document).on('turbo:load', function() {
  var targetNode = document.getElementById('box-msg');
  var config = { attributes: true, childList: true, subtree: true };
  handle_msg_change()
  var callback = function(mutationsList, observer) {
    for(var mutation of mutationsList) {
      if (mutation.type == 'childList') {
        handle_msg_change()
      }
      else if (mutation.type == 'attributes') {
        console.log('The ' + mutation.attributeName + ' attribute was modified.');
      }
    }
  };
  if (targetNode) {
    var observer = new MutationObserver(callback);
    observer.observe(targetNode, config);
  }
});

$(document).on('click', '.btn-edit-msg', function() {
  const $form = $(this).closest('.msg-li');
  $('.box-form-edit-msg').removeClass('active-display-del');
  $form.find('.box-form-edit-msg').addClass('active-display-del');
});


$(document).on('submit', '.form-edit-msg', function(e) {
  e.preventDefault();
  const formData = new FormData(this);
  const msg = $(this).attr('id');
  const parts = msg.split("-");
  const msgID = parts[parts.length - 1];
  const roomID = $(this).closest('.item-msg').data('chat-room-id');
  const value = $(this).closest('.msg-form').find('.msg-content').val();
  console.log(msgID,roomID, value )
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });
  
  $.ajax({
    url: '/chat_rooms/' + roomID + '/messages/' + msgID,
    type: 'PATCH',
    data: formData,
    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    dataType: 'json',
    success: function(response) {},
    error: function(error) {
      console.log(error);
    }
  });
})


$(document).on('DOMContentLoaded', function() {
  var messagesContainer = $('#box-msg');
  function scrollDown() {
    messagesContainer.animate({
      scrollTop: messagesContainer.prop('scrollHeight')
    }, 500);
  }
  $(document).on('turbo:after-stream-append', function() {
    scrollDown();
  });
  scrollDown();
});
  
  
