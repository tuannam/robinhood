var videoSrc = "";

const playMovie = (url) => {    
    console.log(`url = ${url}`);
    if (url.startsWith("resolver-") || url.includes("onedaysales") || url.includes("animeion") || url.includes("ok.ru")) {
        console.log(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`);
        getJSON(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`, function(resp) {  
            console.log(resp)
            videoSrc = resp.url;            
            
            // if (resp.player == 'jwplayer') {
            //     jwplayer("player").setup({ 
            //         "playlist": [{
            //             "file": `${resp.url}`
            //         }]
            //     });    
            // } else 
            if (resp.player == 'ok.ru') {
                document.getElementById('cast-button').hidden = true
                let div = document.getElementById('player')
                let iframe = document.createElement('iframe')
                if (window.screen.width > 600) {
                    iframe.setAttribute('width', '480px')
                    iframe.setAttribute('height', '360px')
                } else {
                    iframe.setAttribute('width', '320px')
                    iframe.setAttribute('height', '240px')
                }                                
                iframe.setAttribute('frameborder', '0')
                iframe.setAttribute('allowfullscreen', true)
                iframe.setAttribute('src', resp.url)
                div.append(iframe)
            } else {
                jwplayer("player").setup({ 
                    "playlist": [{
                        "file": `${resp.url}`
                    }]
                });    

                // let div = document.getElementById('player')
                // let video = document.createElement('video');
                // video.setAttribute('width', '480px')
                // video.setAttribute('controls', true)
                // div.append(video)

                // let source = document.createElement('source');
                // source.setAttribute('src', resp.url)
                // source.setAttribute('type', 'video/mp4')
                // video.appendChild(source)
                // video.play()
            }
        });     
    } else {
        console.log('there');
        window.location = url;
        videoSrc = url;
    }     
};