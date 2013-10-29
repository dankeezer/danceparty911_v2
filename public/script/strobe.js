

var intro = function () {
    $("#strobe").toggleClass('black');
}
var i = setInterval(intro,40);

setTimeout(function () {
    clearInterval(i);
    $("#strobe").hide();
}, 1500);

