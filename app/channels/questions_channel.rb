class QuestionsChannel < ApplicationCable::QuestionsChannel
  def follow
    stream_from 'questions'
  end
end
