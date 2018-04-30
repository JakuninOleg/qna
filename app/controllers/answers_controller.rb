class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created'
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@question), notice: 'Your answer was destroyed'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
