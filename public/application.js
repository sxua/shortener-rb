$(document).ready(function(){
  $('#url_form').submit(function(e){
    e.preventDefault();
    $.post('/u', $('#url_form').serialize(), function(response){
      $('#short').html(response);
    });
  });
});