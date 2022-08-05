var videoSrc = "";

const playMovie = (url) => {    
    console.log(`url = ${url}`);
    if (url.startsWith("resolver-") || url.includes("onedaysales") || url.includes("animeion") || url.includes("ok.ru")) {
        console.log(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`);
        getJSON(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`, function(resp) {  
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
        console.log('there');
        window.location = url;
        videoSrc = url;
    }     
};