const searchMovies = (keyword) => {
    console.log(`keyword = ${keyword}`);
    getJSON(`/cgi-bin/search.cgi?${keyword}`, function(movies) {  
        console.log(movies);

        let output = `<div class="head">
                        <h2>${name}</h2>
                        <br/>
                    </div>`
        movies.forEach(
            ({ article_code, article_image, article_title }) => {       
              if (offset % 5 == 0) {
                output += `<div class="box">`
              } 
              (output += movieCard(article_code, article_title, article_image))
              offset = offset + 1;
              if (offset % 5 == 0) {
                output += `</div>`
              }
            }
              
          )    
          box.innerHTML += output;
    });
};
