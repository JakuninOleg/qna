$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      console.log('Connected!');
      this.perform('follow');
    },

    received: function(data) {
      $('.questions').prepend(data);
    }
  });
});
