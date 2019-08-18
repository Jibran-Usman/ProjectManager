# frozen_string_literal: true

class CommentsController < ApplicationController
  def index
    @comments = Comment.search(params[:commentable_id], params[:commentable_type]).page(params[:page])
    authorize @comments

    respond_to do |format|
      format.js
    end
  end

  def new
    @comment = Comment.new
    authorize @comment

    respond_to do |format|
      format.js
    end
  end

  def create
    @comment = Comment.new(comment_params)
    authorize @comment

    if @comment.save
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment

    @type = @comment.commentable_type
    @id = @comment.commentable_id
    @comment.destroy

    @path = send('decide_' + @type.underscore.to_s + '_path', @id)
    redirect_to @path, notice: 'Comment successfully deleted'
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :commenter_id, :commentable_type, :commentable_id)
  end
end
