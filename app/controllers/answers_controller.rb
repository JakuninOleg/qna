class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer was destroyed'
    else
      flash[:alert] = "You can not delete other users' answers"
    end
    redirect_to question_path(@question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
