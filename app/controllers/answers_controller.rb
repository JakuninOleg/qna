class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy choose_best]
  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      flash[:alert] = "You can not update other users' answers"
    end
  end

  def destroy
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:alert] = "You can not delete other users' answers"
    end
  end

  def choose_best
    if current_user.author_of?(@answer.question)
      @answer.set_best
      flash[:notice] = 'Best answers was chosen successfully'
    else
      flash[:alert] = 'You can not choose best answer for not yours question'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = @answer.attachments.map do |attach|
      { id: attach.id, url: attach.file.url, name: attach.file.identifier }
    end

    ActionCable.server.broadcast("answers_for_question_#{@answer.question_id}",
     answer: @answer,
     attachments: attachments,
     question_user_id: @answer.question.user_id,
     rating: @answer.votes
     )
  end
end
