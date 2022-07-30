let category = "";
let offset = 0;
let busy = false
box = document.querySelector('.container');


function movideCard(code, title, image) {
  return `<div class="movie">
    <div class="movie-image"> 
      <span class="play"><span class="name">${title}</span></span> 
      <a href="/?details/${code}"><img src="${image}" alt="" /></a> 
    </div>
    <div class="rating"><span class="comments"></span> </div>
  </div>`
};

const loadMore = () => {
  console.log("near bottom!");
  if (busy) {
    return
  }
  busy = true
  let output = ""

  console.log(`offset = ${offset}`);
  $.getJSON(`/cgi-bin/category.cgi?${category}/${offset}/15`, function(movies) {  
    movies.forEach(
      ({ article_code, article_title, article_image }) => {       
        if (offset % 5 == 0) {
          output += `<div class="box">`
        } 
        (output += movideCard(article_code, article_title, article_image))
        offset = offset + 1;
        if (offset % 5 == 0) {
          output += `</div>`
        }
      }
        
    )    
    box.innerHTML += output;
    busy = false;
  }); 
};

const showMovies = (name, category, container, all = false) => {
  let box = document.querySelector(container)
  let output = `<div class="head">
                  <h2>${name}</h2>`
      if (all) {
        output += `<br/>`
      } else {
        output += `<p class="text-right"><a href="/?${category}">See all</a></p>`
      } 
      output += `</div>`
  let limit = 10
  if (all) {
    limit = 15
  }
  $.getJSON(`/cgi-bin/category.cgi?${category}/0/${limit}`, function(movies) {    
    movies.forEach(
      ({ article_code, article_title, article_image }) => {
        if (offset % 5 == 0) {
          output += `<div class="box">`
        }
        (output += movideCard(article_code, article_title, article_image))
        offset = offset + 1;       
        if (offset % 5 == 0) {
          output += `</div>`
        }
      }
       
    )
    if (!all) {
      output += `<div class="cl">&nbsp;</div>`
    }
    
    box.innerHTML = output
  }); 
};

let path = $(location).attr('search');
if (path.startsWith('?phimle')) {
  category="phimle"
  box = document.querySelector('.container')
  box.innerHTML = `<div class="phim-le"></div>`
  document.addEventListener("DOMContentLoaded", showMovies('Phim Lẻ', 'phimle', '.phim-le', true));
} else if (path.startsWith('?phimbo')) {
  category="phimbo"
  box = document.querySelector('.container')
  box.innerHTML = `<div class="phim-bo"></div>`
  document.addEventListener("DOMContentLoaded", showMovies('Phim Bộ', 'phimbo', '.phim-bo', true));
} else if (path.startsWith('?phimchieurap')) {
  category="phimchieurap"
  box = document.querySelector('.container')
  box.innerHTML = `<div class="phim-chieu-rap"></div>`
  document.addEventListener("DOMContentLoaded", showMovies('Phim Chiếu Rạp', 'phimchieurap', '.phim-chieu-rap', true));
} else if (path.startsWith('?details')) {
  box = document.querySelector('.container')
  let code = path.substring(9);
  box.innerHTML = `<div class="details"></div>`
  document.addEventListener("DOMContentLoaded", loadMovie(code));
} else if (path.startsWith('?play')) {
  box = document.querySelector('.container')
  box.innerHTML = `<div class="play-area"></div>`
  let url = decodeURIComponent(path.substring(6));
  console.log(url);
  document.addEventListener("DOMContentLoaded", playMovie(url));
} else {
  document.addEventListener("DOMContentLoaded", showMovies('Phim Chiếu Rạp', 'phimchieurap', '.phim-chieu-rap'));
  document.addEventListener("DOMContentLoaded", showMovies('Phim Lẻ', 'phimle', '.phim-le'));
  document.addEventListener("DOMContentLoaded", showMovies('Phim Bộ', 'phimbo', '.phim-bo'));
}

$(window).scroll(function() {
  if($(window).scrollTop() + $(window).height() > $(document).height() - 100) {
    if (category != "") {
      loadMore();
    }      
  }
});