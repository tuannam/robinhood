var videoSrc = "";

const playMovie = (url) => {    
    console.log(`url = ${url}`);
    if (url.includes("onedaysales") || url.includes("animeion")) {
        $.getJSON(`/cgi-bin/resolve.cgi?${url}`, function(resp) {  
            videoSrc = resp.url;
            
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
        videoSrc = url;
    }     
};