class TweetsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @q = Tweet.ransack(params[:q])
    @tweets = @q.result.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      redirect_to @tweet, notice: 'Tweet was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tweet.update(tweet_params)
      respond_to do |format|
        format.html { redirect_to @tweet, notice: "Tweet was successfully updated." }
        format.json { render :show, status: :ok, location: @tweet }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tweet.destroy!
    respond_to do |format|
      format.html { redirect_to tweets_path, notice: "Tweet was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:title, :content, :user_id) # adjust attributes as needed
  end

  def authorize_user!
    unless @tweet.user == current_user
      redirect_to tweets_path, alert: 'Not authorized'
    end
  end
end
