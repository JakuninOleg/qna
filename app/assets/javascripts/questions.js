let questionReady = function() {
  $(document).on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).show();
  });
};

$(document).ready(questionReady);
$(document).on('turbolinks:load', questionReady);
