
$( document ).ready(function() {
    $('.playButton').click(function(){
        if ($(this).prev().get(0).paused) {
            // $('#main').find('video').e   ach(function() {$(this).get(0).pause(); });
            $(this).prev().get(0).play();
            $(this).prev().get(0).setAttribute('controls', 'controls')
            $(this).hide()
        }
    });    
});

