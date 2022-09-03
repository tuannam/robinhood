const loadMovie = (code) => {
    let box = document.querySelector('.details')
    console.log(`/cgi-bin/details.cgi?${code}`);
    getJSON(`/cgi-bin/details.cgi?${code}`, function(movies) {  
        console.log(movies);
        let movie = movies[0];
        let servers = ""
        movie['extra_info'].forEach(server => {
            servers += `<span class="server">`
			server['chapters'].forEach(chapter => {
	            let url = chapter["link"].trim();
	            servers += `<a href="/?play/${encodeURIComponent(url)}">${chapter["name"]}</a>`
			});
            servers += `</span>`
        });
        box.innerHTML = 
        `<table>
            <tr valign="top">
                <td><img src="${movie["article_image"]}" alt="" width="300px"/></td>
            </tr>
            <tr valign="top">
                <td>
                <article class="flim-info">
                <div class="pc">
                    <h2 class="flim-title vi">${movie.article_title}</h2>
                    <h3 class="flim-title eng">${movie.article_title_en}</h3>
                </div>
                </article>
                </td>
            </tr>
            <tr><td width="250">${movie.article_content}</td></tr>
            <tr>
                <td>${servers}</td>
            </tr>
        </table>
        <br>
        <br>
        `
        }); 
    
};


