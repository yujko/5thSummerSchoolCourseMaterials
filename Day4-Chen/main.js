//
//  main functions
//
//  xac@ucla.edu, 7/14/2019
//

var GEXTURES = GEXTURES || {};

//
//  set up the system
//
$(document).ready(function () {
    GEXTURES.sandboxTest();

    $('#cvsMain')[0].width = 800;
    $('#cvsMain')[0].height = 500;
    $('#cvsMain').css('background-color', '#eeeeee');

    GEXTURES.context = $('#cvsMain')[0].getContext('2d');
    GEXTURES.context.strokeStyle = "#df4b26";
    GEXTURES.context.lineJoin = "round";
    GEXTURES.context.lineWidth = 5;

    $('#cvsMain').on('mousedown', GEXTURES.canvasMouseDown);
    $('#cvsMain').on('mousemove', GEXTURES.canvasMouseMove);
    $('#cvsMain').on('mouseup', GEXTURES.canvasMouseUp);
});

//
//  sandbox testing specific functions
//
GEXTURES.sandboxTest = function () {}

//
//  handling mousedown on the main canvas
//
GEXTURES.canvasMouseDown = function (e) {
    GEXTURES.coords = [];
    GEXTURES.context.clearRect(0, 0, $('#cvsMain').width(), $('#cvsMain').height());
    GEXTURES.context.beginPath();

    var rect = $('#cvsMain')[0].getBoundingClientRect();
    GEXTURES.context.moveTo(e.clientX - rect.left, e.clientY - rect.top);
    GEXTURES.context.stroke();

    GEXTURES.isDragging = true;

    GEXTURES.coords.push({
        x: e.clientX - rect.left,
        y: e.clientY - rect.top
    })
};

//
//  handling mousemove on the main canvas
//
GEXTURES.canvasMouseMove = function (e) {
    if (!GEXTURES.isDragging) return;

    var rect = $('#cvsMain')[0].getBoundingClientRect();
    GEXTURES.context.lineTo(e.clientX - rect.left, e.clientY - rect.top);
    GEXTURES.context.moveTo(e.clientX - rect.left, e.clientY - rect.top);
    GEXTURES.context.stroke();


    GEXTURES.coords.push({
        x: e.clientX - rect.left,
        y: e.clientY - rect.top
    })
};

//
//  handling mouseup on the main canvas
//
GEXTURES.canvasMouseUp = function (e) {
    var rect = $('#cvsMain')[0].getBoundingClientRect();
    GEXTURES.coords.push({
        x: e.clientX - rect.left,
        y: e.clientY - rect.top
    })
    
    let gesture = GEXTURES.recognize(GEXTURES.coords);
    console.log(gesture);
    $('#divInfo').html(gesture ? gesture : 'No gesture recognized')

    GEXTURES.isDragging = false;
    GEXTURES.context.closePath();
};