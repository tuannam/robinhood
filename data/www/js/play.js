var videoSrc = "";

const playMovie = (url) => {    
    console.log(`url = ${url}`);
    let div = document.getElementById('player')
    let video = document.createElement('video');
    video.setAttribute('width', '480px')
    video.setAttribute('controls', true)
    div.append(video)

    if (url.startsWith("resolver-") || url.includes("onedaysales") || url.includes("animeion") || url.includes("ok.ru")) {
        console.log(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`);
        getJSON(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`, function(resp) {  
            if (resp.player == 'proxy') {
                var getUrl = window.location;
                var baseUrl = getUrl .protocol + "//" + getUrl.host + "/" + getUrl.pathname.split('/')[1];
                videoSrc = `${baseUrl}cgi-bin/proxy.cgi?${encodeURIComponent(resp.url)}`;
            } else {
                videoSrc = resp.url;
            }
            
            console.log(resp)

            if (resp.player == 'jwplayer') {
                jwplayer("player").setup({ 
                    "playlist": [{
                        "file": `${resp.url}`
                    }]
                });    
            } else {
                let source = document.createElement('source');
                source.setAttribute('src', resp.url)
                source.setAttribute('type', 'video/mp4')
                video.appendChild(source)
                video.play()
            }
        });     
    } else {
        console.log('there');
        window.location = url;
        videoSrc = url;
    }     
};