const getJSON = (url, success) => {
    $.ajax({
      beforeSend: function(request) {
          request.setRequestHeader("X-MOVIE-SITE", Cookies.get("site"));
      },
      dataType: "json",
      url: url,
      success: success
    });
  };