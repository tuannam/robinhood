var videoSrc = "";

const playMovie = (url) => {    
    console.log(`url = ${url}`);
    if (url.startsWith("resolver-") || url.includes("onedaysales") || url.includes("animeion") || url.includes("ok.ru")) {
        console.log(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`);
        getJSON(`/cgi-bin/resolve.cgi?${encodeURIComponent(url)}`, function(resp) {  
            videoSrc = resp.url;
            console.log(resp)
            jwplayer("player").setup({ 
                "playlist": [{
                    "file": `${resp.url}`
                }]
            });
        });     
    } else {
        console.log('there');
        window.location = url;
        videoSrc = url;
    }     
};