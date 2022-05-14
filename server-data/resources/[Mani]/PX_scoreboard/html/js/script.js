let visible = false;
let shows = {
    "weazel": true,
    "police": true,
    "ambulance": true,
    "taxi": true,
    "dadgostari": true
};

$(function() {
    window.addEventListener('message', function(event) {
        switch(event.data.action){
            case "toggler":
                if (visible) {
                    $("#wrap").fadeOut(500);
                } else {
                    $('#wrap').fadeIn(500);
                };
                visible = !visible;
                break;
            case "close":
                $("#wrap").fadeOut(500);
                visible = false;
                break;
            case "updateInfo":
                if(event.data.data){
                    let data = event.data.data;
                    let i;
                    for (i in data) {
                        if (shows[i]) {
                            $("." + i + " p").html(data[i]);
                        };
                    };

                    $("#Vrealstates").html(data['realstate']);
                    $("#Vcount").html(data['total']);
                };
                break;
            default:
                console.log("Unknown Case ...");
                break;
        };
    }, false);
});

let time;
function getCurrentTime(){
    time = new Date().toLocaleTimeString();
    $('.clock').html(time);
};

setInterval(getCurrentTime, 1000);