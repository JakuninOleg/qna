class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show edit destroy update publish_question]
  before_action :build_answer, only: :show
  before_action :find_subscription, only: %i[show update]

  after_action :publish_question, only: :create

  authorize_resource

  respond_to :js

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answers = @question.answers.by_best
    respond_with(@question)
  end

  def new
    respond_with(@question = current_user.questions.build)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with @question
    end
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def find_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions',
      question: @question,
      rating: @question.votes,
      email: @question.user.email )
  end

  def build_answer
    @answer = @question.answers.build
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end
