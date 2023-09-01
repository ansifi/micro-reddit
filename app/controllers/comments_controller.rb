class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
    @comment = Comment.find(params[:id])
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @post = Post.find(params[:comment][:post_id])
    @comment = @post.comments.build(comment_params)
    if @comment.user == current_user  # Check if the current user is the comment's author
      respond_to do |format|
        if user_signed_in?  # Check if the user is authenticated
          if @comment.save
            format.html { redirect_to post_url(@post), notice: "Comment was successfully created." }
            format.json { render :show, status: :created, location: @comment }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        else
          redirect_to new_user_session_path, alert: "Please log in to create a comment."
        end
      end
    else
      redirect_to post_path(@post), alert: "You are not authorized to create this comment."
    end
  end
  

  # PATCH/PUT /comments/1 or /comments/1.json

  def update
    @comment = Comment.find(params[:id])
  
    if @comment.user == current_user  # Check if the current user is the comment's author
      respond_to do |format|
        if @comment.update(comment_params)
          format.html { redirect_to post_path(@comment.post), notice: "Comment was successfully updated." }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to post_path(@comment.post), alert: "You are not authorized to edit this comment."
    end
  end
  
  

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body).merge(user: current_user)
    end
    
end
