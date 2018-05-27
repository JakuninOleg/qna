class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: %i[index show]

  before_action :find_question, only: %i[show edit destroy update]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.by_best
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question succesfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      flash[:alert] = "You can't delete other users questions"
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question was successfully deleted'
    else
      flash[:alert] = "You can not delete other users' questions"
    end
    redirect_to questions_path
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
