const loadMovie = (code) => {
    let box = document.querySelector('.details')
    getJSON(`/cgi-bin/details.cgi?${code}`, function(movies) {  
        console.log(movies);
        let movie = movies[0];
        let titles = movie["article_title"].split('-');
        let chapters = ""
        movie['extra_info'].forEach(chapter => {
            chapters += `<span class="chapter">`
            let url = chapter["link"].trim();
            chapters += `<a href="/?play/${encodeURIComponent(url)}">${chapter["name"]}</a>`
            if (chapter["link2"]) {
                let url2 = chapter["link2"].trim();
                chapters += `&nbsp;&nbsp;<a href="/?play/${encodeURIComponent(url2)}">Link 2</a>`
            }
            if (chapter["link3"]) {
                let url3 = chapter["link3"].trim();
                chapters += `&nbsp;&nbsp;<a href="/?play/${encodeURIComponent(url3)}">Link 3</a>`
            }
            chapter += `</span>`
        });
        var content=decodeURIComponent(movie.article_content)
        var contentDiv = document.createElement('div')
        contentDiv.innerHTML = content
        
        var html = contentDiv.firstChild.innerHTML
        if (contentDiv.firstChild.firstChild.nodeName == "P") {
            html = contentDiv.firstChild.firstChild.innerHTML
        }
        box.innerHTML = 
        `<table>
            <tr valign="top">
                <td><img src="${movie["article_image"]}" alt="" /></td>
            </tr>
            <tr valign="top">
                <td>
                <article class="flim-info">
                <div class="pc">
                    <h2 class="flim-title vi">${titles[0]}</h2>
                    <h3 class="flim-title eng">${titles[1]}</h3>
                </div>
                </article>
                </td>
            </tr>
            <tr><td width="250">${html}</td></tr>
            <tr>
                <td>${chapters}</td>
            </tr>
        </table>
        <br>
        <br>
        `
        }); 
    
};


