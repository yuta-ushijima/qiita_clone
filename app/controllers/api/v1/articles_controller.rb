class Api::V1::ArticlesController < ApplicationController
  # TODO: Devise の調整が完了したら、:updateと:deleteを外すようにする
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_article, only: [:update, :destroy]

  def index
    @articles = Article.order("created_at desc")
    render json: @articles
  end

  def show
    @article = Article.find(params[:id])
    if @article.present?
      render json: @article, status: 200
    else
      render json: @article, status: 400
    end
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save!
      render json: @article, serializer: ArticleSerializer, status: 200
    else
      render json: @article, status: 400
    end
  end

  def update
    if @article.present?
      @article.update!(article_params)
      render json: @article, serializer: ArticleSerializer, status: 200
    else
      render json: @article, serializer: ArticleSerializer, status: 400
    end
  end

  def destroy
    @article.destroy!
    render json: @article, serializer: ArticleSerializer, status: 204
  end

  private

    def article_params
      params.require(:article).permit(:title, :body)
    end

    def set_article
      # TODO: Devise の調整が完了したらcurrent_userから取得するようにする
      @article = current_user.articles.find(params[:id])
    end
end
