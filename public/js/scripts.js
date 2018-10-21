$(document).ready(function () {
    let colorRegion = '#1076C8'; // Цвет всех регионов
    let focusRegion = '#FF9900'; // Цвет подсветки регионов при наведении на объекты из списка
    let selectRegion = '#0A4C82'; // Цвет изначально подсвеченных регионов
    let sortBy = "name"

    /*Почему к JSON'у не могу обратиться как к хешмапу*/

    $('#vmap').vectorMap({
        map: 'russia',
        backgroundColor: '#ffffff',
        borderColor: '#ffffff',
        borderWidth: 2,
        color: colorRegion,
        hoverOpacity: 0.7,
        enableZoom: true,
        showTooltip: true,
        onLabelShow: function (event,label,code) {
            $(label).append();
        },
        selectedColor: focusRegion,

        // Клик по региону
        onRegionClick: function (element, code, region) {
            $.getJSON("/region", {region: code}, function (data) {
                $("h1").text(data["region_name"]);
                deeds = toHashMap(JSON.parse(data["deeds"]));
                sortProperties(deeds, sortBy);
                printDeputies();
                console.log(deeds)
            })
        }
    });

    function printDeputies() {
        $(".deputies").find(".deed").remove();
        $.each(deeds, function (index) {
            //TODO: ВЫВОД ПОЛЕЙ
            /*tr = "<tr class='deed'>";
            $.each(JSON.parse(value), function(arrKey, arrValue){
                tr += "<td>" + arrValue + "</td>";
            });
            tr += "</tr>";
            $(".deputies").append(tr);*/
            tr = "<tr class='deed " + deeds[index]["deed_id"] + "'>";
            tr += "<td ><img class=\"deputy-img\" src='" + deeds[index]["photo_href"] + "' alt='" + deeds[index]["name"] + "'>" + "</td>";
            tr += "<td>" + deeds[index]["name"] + "</td>";
            tr += "<td>" + deeds[index]["surname"] + "</td>";
            tr += "<td>" + deeds[index]["patronymic"] + "</td>";
            tr += "<td>" + deeds[index]["position"] + "</td>";
            tr += "<td>" + deeds[index]["sign"] + "</td>";
            tr += "<td>" + deeds[index]["detriment"] + "</td>";
            tr += "<td>" + deeds[index]["punishment"] + "</td>";
            tr += "<td>" + deeds[index]["status"] + "</td>";
            tr += "<td>" + deeds[index]["date"] + "</td>";
            links = deeds[index]["proof_links"].split(" ");
            tr += "<td><ul>";
                $.each(links, function (index) {
                    console.log(links[index]);
                    tr += "<li><a href='" +links[index]+ "'>" + links[index] + "</a></li>";
                })
            tr += "</ul></td>";
            $(".deputies").append(tr)
        })
    }

    $('*[data-href]').on("click", function () {
        window.location = $(this).data('href');
        return false;
    });

    $('*[data-sort-by]').on("click", function () {
        if (deeds != null) {
            sortProperties(deeds, $(this).data('sort-by'));
            printDeputies();
        }
        return false;
    });

    $('.proof-link').on("click", function () {
        $('#proof_link').append("hihi")
    });

    function toHashMap(obj) {
        var sortable = [];
        for (var key in obj)
            if (obj.hasOwnProperty(key))
                sortable.push(JSON.parse(obj[key])); // each item is an array in format [key, value]
        return sortable;
    }

    function sortProperties(obj, title) {
        if (title != sortBy) {
            obj.sort(function (a, b) {
                if (a[title] > b[title])
                    return 1
            });
        } else {
            obj.reverse()
        }
    }

});
