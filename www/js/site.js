getJSON(`/cgi-bin/site.cgi`, function(sites) {    
    console.log(sites);
    sites.forEach(site => {
        $('#sites').append($('<option>', {
            value: site,
            text: site,
            selected: site == Cookies.get("site")
          }));
    });           
}); 

$('#sites').change(function() {    
    Cookies.set("site", this.value);
    window.location.href = "/";
});