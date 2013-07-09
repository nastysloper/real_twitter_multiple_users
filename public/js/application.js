$(document).ready(function() {
  $('form').on('submit', function(e){
    e.preventDefault();
    var form = $(this);
    form.hide();
    $('#loader').show();
    $.ajax({
      method: 'post',
      url: '/tweet',
      data: $(this).serialize()
    })
    .done(function(response) {
      $('#loader').hide();
      form.fadeIn();
      // add recent_tweets function call?
    });
  });
});

var recent_tweets = function(){
  $.ajax({
      method: 'get',
      url: '/recent_tweets'
    })
    .done(function(response) {
      console.log(response);
    });
};
