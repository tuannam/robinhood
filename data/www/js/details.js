const loadMovie = (code) => {
    let box = document.querySelector('.details')
    $.getJSON(`/cgi-bin/details.cgi?${code}`, function(movies) {  
        let movie = movies[0];
        // console.log(movie);
        let titles = movie["article_title"].split('-');
        let chapters = ""
        movie['extra_info'].forEach(chapter => {
            let url = chapter["link"].trim();
            chapters += `<a href="/?play/${encodeURIComponent(url)}"><span class="chapter">${chapter["name"]}</span></a>`
        });
        console.log(chapters);
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
            <tr>
                <td>${chapters}</td>
            </tr>
        </table>
        `
        }); 
    
};


