$(document).ready(function(){
  var oldValue;
  $('#url_form').submit(function(e){
    e.preventDefault();
    if ($('#url').val().length > 10) {
      if (oldValue != $('#url').val()) {
        $('#short').html('');
        $.post('/u', $('#url_form').serialize(), function(response){
          $('#short').html(response);
          $('#url_form input[type="submit"]').attr('disabled', 'disabled');
          oldValue = $('#url').val();
        });
      }
      setTimeout(function(){$('#url_form input[type="submit"]').removeAttr('disabled');}, 5000);
    } else {
      $('#short').html("<p>URL is too short</p>");
    }
  });
});