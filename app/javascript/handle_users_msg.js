function handle_msg_change() {
  let user = $('#chatroom_container').data('user');

  if (user) {
    $('.msg-li-' + user).addClass('active-msg-current-user')
    $('.cont-' + user).addClass('active-msg-box')
    $('.message-delete-' + user).addClass('active-display-del')
  }
}

$(document).on('turbo:load', function() {
  var targetNode = document.getElementById('messages');
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
  
  var observer = new MutationObserver(callback);
  observer.observe(targetNode, config);
});