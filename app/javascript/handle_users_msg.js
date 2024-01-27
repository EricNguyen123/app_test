function handle_msg_change() {
  var messagesContainer = $('#box-msg');
  messagesContainer.scrollTop(messagesContainer.prop('scrollHeight'));
  let user = $('#chatroom_container').data('user');

  if (user) {
    $('.msg-li-' + user).addClass('active-msg-current-user');
    $('.cont-' + user).addClass('active-msg-box');
    $('.message-delete-' + user).addClass('active-display-del');
    $('.btn-edit-msg-' + user).addClass('active-display-del');
    $('.box-form-edit-msg').removeClass('active-display-del');
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
        var messagesContainer = $('#box-msg');
        messagesContainer.scrollTop(messagesContainer.prop('scrollHeight'));
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

$(document).on('DOMContentLoaded', function() {
  var messagesContainer = $('#box-msg');
  function scrollDown() {
    messagesContainer.animate({
      scrollTop: messagesContainer.prop('scrollHeight')
    }, 500);
  }
  scrollDown();
});
  
  
