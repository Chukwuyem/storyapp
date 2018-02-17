
function loadStories(){
    $.ajax({
        url: '/get/stories',
        type: 'GET',
        dataType: 'json',
        error: function(data){
            console.log('loading stories failed')
            console.log(data)
        },
        success: function(data){
            console.log('We have stories')
            console.log(data)

            $('#stories').html('')
            for(let i=0; i<data.length; i++){
                let eachStory = ''
                eachStory += `<div class="eachStory">`
                eachStory += `<h3><a href="#">`+data[i].title+`</a></h3>`
                eachStory += `<p>`+data[i].created_at+`</p>`
                eachStory += `<p>Story Description: `+data[i].description+`</p>`
                //eachStory += `<p>Read More...</p>`
                $('#stories').append(eachStory)
            }

        }
    })
}


$(document).ready(function(){
    console.log('home is ready')

    loadStories()
})