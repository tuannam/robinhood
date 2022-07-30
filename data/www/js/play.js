const playMovie = (url) => {
    console.log(`url = ${url}`);
    if (url.includes("onedaysales")) {
        $.getJSON(`/cgi-bin/resolve.cgi?${url}`, function(resp) {  
            console.log(resp.url)
            let video = document.getElementById("player")
            var source = document.createElement('source');
            source.setAttribute('src', resp.url);
            source.setAttribute('type', 'video/mp4');
            video.appendChild(source);
            video.play();
        }); 
    } else {
        window.location = url;
    }     
};