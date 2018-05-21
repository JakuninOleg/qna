var ready = function() {
  $('.vote').bind('ajax:success', function(e) {
    [data, status, xhr] = e.detail;
    parentClass = ".rating_" + data.klass + "_" + data.id;
    afterVote(parentClass, vote.rating);
  });
  function afterVote(parent, rating) {
    $(parent + " span").html(rating);
    $(parent + ' .vote-reset').toggle();
    $(parent + ' .vote-up').toggle();
    $(parent + ' .vote-down').toggle();
  };
};

$(document).on('turbolinks:load', ready);
