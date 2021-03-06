var commentsChannel = function () {
  var questionId = $('.question').data('id')

  App.cable.subscriptions.create({ channel: 'CommentsChannel', id: questionId }, {
    connected: function() {
      console.log('Connected comments!');
      this.perform('follow');
    },

    received: function(data) {
      if (data.comment.user_id != gon.user_id) {
        var parentClass = $('.comment_' + data.comment.commentable_type.toLowerCase() + '_' + data.comment.commentable_id)
        $(parentClass).append(JST['templates/comment'](data));
      }
    }
  });
};

$(document).on('turbolinks:load', commentsChannel);
