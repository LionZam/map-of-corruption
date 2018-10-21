jQuery.extend(jQuery.validator.messages, {
    required: "Это поле обязательно",
    number: "Необходимо ввести число"
})
$(function () {
    $('#form').validate({
        rules: {
            detriment: {
                number: true,
            },
            deputy_id: {
                number: true
            },
        },
    });
    $("#form input, #form textarea").each(function () {
        $(this).rules("add", {
            required: true // Or whatever rule you want
        });
    });
});

proof_link_counter = 0;
$('.proof-link').on("click", function () {
    proof_link_counter++
    id =
        $("<input class=\"form-control\" id=\"proof_link" + proof_link_counter + "\" name=\"proof_link" + proof_link_counter + "\">").insertAfter($('#proof_link' + --proof_link_counter));
    proof_link_counter++;
    console.log(proof_link_counter)
});