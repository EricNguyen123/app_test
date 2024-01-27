import consumer from "./consumer"

$(document).on('turbo:load', function() {

  const chat_room_id = $('#single_room').data('chat-room-id')

  consumer.subscriptions.subscriptions.forEach((subscription) => {
    consumer.subscriptions.remove(subscription)
  })

  consumer.subscriptions.create({ channel: "ChatRoomChannel", chat_room_id: chat_room_id } , {
    connected() {
      // Called when the subscription is ready for use on the server
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      if (data.action === 'create') {
        $('#messages').append(data.html);
      }
      else if (data.action === 'update') {
        $('#msg-cnt-id-' + data.msg_id).html(data.html);
      }
      else if (data.action === 'destroy') {
        $('#message_' + data.msg_id).remove();
      }
    }
  });
  
})
