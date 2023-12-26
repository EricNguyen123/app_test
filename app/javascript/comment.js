$('.btn-reply-<%=j dom_id(comment) %>').on("click", ()=>{
    $('div').removeClass('box-reply')
    $('.box-reply-<%=j dom_id(comment) %>').css({
        display: "flex !important",
    })
    
})