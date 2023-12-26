$('.btn-reply-<%=j dom_id(comment) %>').on("click", ()=>{
    alert('You clicked the Hide link');
    $('.box-reply-<%=j dom_id(comment) %>').css({
        display: "block !important",
    })

})