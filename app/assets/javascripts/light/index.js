$(function () {
    $('input[name="my-checkbox"]').on('switchChange.bootstrapSwitch', function (event, state) {
        var status = state == true ? "on" : "off";
        var data = {"section": this.id, "status": status};

        $.post(SMARTCONTROL.domain + "/smart_light_control/publish", data, function () {
            console.log(data);
        });
    });
});