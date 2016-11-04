$(function () {
    $('#south-side-toggle').change(function () {
        var data = {"light_num": "south", "status": "off"};

        if (!$(this).parent().hasClass("off")) {
            data = {"light_num": "south", "status": "on"}
        }

        $.post("http://localhost:3000/smart_light_control/publish", data, function () {
         console.log(data);
        });
    });

    $('#middle-side-toggle').change(function () {
        $.post("http://localhost:3000/smart_light_control/publish", {"light_num": "middle"}, function () {
            alert("success")
        });
    });

    $('#north-side-toggle').change(function () {
        $.post("http://localhost:3000/smart_light_control/publish", {"light_num": "north"}, function () {
            alert("success")
        });
    });
});