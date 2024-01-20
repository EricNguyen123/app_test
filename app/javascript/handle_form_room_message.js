$(document).off('click', '.btn-msg-chat').on('click', '.btn-msg-chat', function(e){
  setTimeout(function(){
    $('.input-form-msg').val('');
  }, 200)
})

$(document).off('click', '.btn-chat').on('click', '.btn-chat', function(e){
  setTimeout(function(){
    $('.input-form-room').val('');
  }, 200)
})
