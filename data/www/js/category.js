getJSON(`/cgi-bin/home.cgi`, function(resp) {    
    console.log(resp);
    let path = $(location).attr('search');
    let id = path.substring(10);        
    resp['categories'].forEach(category => {
        let active = ''
        if (id == category.id) {
            active = 'active'
        }
        console.log(`active = ${active}`);
        $("#nav-ul").append(`<li><a class="${active}" href="/?category/${category.id}">${category.name}</a></li>`);
    });           
}); 