class ArticlesController < ApplicationController
  
  def index
    if user_signed_in?
      if params[:filter] == "My"
        @pagy, @articles = pagy(Article.where(user_id: current_user.id).all, items: 2)
      else
        @pagy, @articles = pagy(Article.all, items: 2)
      end
    else
      @pagy, @articles = pagy(Article.all, items: 2)
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  private
    def article_params
      params.require(:article).permit(:title, :body, :image)
    end
    
end
