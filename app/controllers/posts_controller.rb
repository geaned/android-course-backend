class PostsController < ApplicationController

  before_action :validate_query
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :set_posts_page, only: :index

  def index
    render json: {posts: @posts, next: @next_page_exists}
  end

  def create
    @post = Post.new(post_params)
    if @post.valid?
      @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unauthorized
    end
  end

  def show
    render json: @post
  end

  def update
    @post.update(post_params)
    head :no_content
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.permit(:link, :image, :title, :text)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_posts_page
    post_count = request.query_parameters.has_key?("pageSize") ? params["pageSize"].to_i : Post.count
    if post_count <= 0
      post_count = Post.count
    end
    
    cursor_from = request.query_parameters.has_key?("from") ? params["from"] : Time.now
    @posts = Post.where("updated_at < ?", cursor_from).order(updated_at: :desc).limit(post_count+1)
    @next_page_exists = @posts.length == post_count+1

    # dropping an extra item, which was used to check the presence of the next page, if needed
    if @next_page_exists
      @posts = @posts[0...-1]
    end
  end
end
