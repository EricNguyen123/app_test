
$(".bar-btn").on("click", ()=>{
    $(".bar-content").css({
        display: "block !important",
    })

    $("ul").removeClass("collapse")
})
