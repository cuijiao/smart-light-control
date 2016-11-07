// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function () {
    $('.image-panel .img1').click(event, function () {
        $('.image-panel .img1').toggleClass('disable');

        event.preventDefault();
    });

    $('.image-panel .img2').click(event, function () {
        $('.image-panel .img2').toggleClass('disable');

        event.preventDefault();
    });

    $('.image-panel .img3').click(event, function () {
        $('.image-panel .img3').toggleClass('disable');

        event.preventDefault();
    });

    $('.image-panel .img4').click(event, function () {
        $('.image-panel .img4').toggleClass('disable');

        event.preventDefault();
    });
});
