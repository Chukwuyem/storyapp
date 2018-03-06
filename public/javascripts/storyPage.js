

function loadNextPara() {

    let nextparaprid = $('#nextPara').data("para-id")
    console.log(nextparaprid)
    if (nextparaprid !== "NULL"){
        let nextparaURL = '/para/' + nextparaprid

        $.ajax({
            url: nextparaURL,
            type: 'GET',
            dataType: 'json',
            error: function(data){
                console.log('loading paragraphs failed')
                console.log(data)
            },
            success: function (data) {
                console.log('next paragraph loaded')
                console.log(data)

                let newParaHTML = ''
                newParaHTML += '<div class="eachPara" id="'
                newParaHTML += data.prid
                newParaHTML += '"> <p>'
                newParaHTML += data.maintext
                newParaHTML += '</p></div>'

                $("#storyParas").append(newParaHTML)

                $('#nextPara').data("para-id", data.childpr)
                //<div class="eachPara"> <p> {{ firstpara }} </p> </div>
            }
        })
    }

}

$(document).ready(function(){
    console.log('story page is ready')

    ///////
    console.log(typeof(window.location.href))
    let currURL = window.location.href

    currURL = currURL.split('/')
    let stID = currURL[currURL.length - 1]
    console.log(stID)
    //////


    $('#loadNextPara').click(function(){
        console.log("Clicked the load next paragraph button")

        loadNextPara()
    })


})