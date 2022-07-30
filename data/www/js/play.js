const playMovie = (url) => {
    console.log(`url = ${url}`);
    $.getJSON(`/cgi-bin/resolve.cgi?${url}`, function(resp) {  
        console.log(resp.url)
        let box = document.querySelector('.play-area')
        box.innerHTML = `
        <video controls width="100%">
            <source src="${resp.url}" type="video/mp4">
        </video>
        `
    }); 
};