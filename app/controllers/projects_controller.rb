# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_client
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = if params[:name]
                  @client.projects.where('name LIKE ?', "%#{params[:name]}%").page(params[:page])
                else
                  @client.projects.page(params[:page])
                end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show; end

  # GET /projects/new
  def new
    @project = @client.projects.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects
  # POST /projects.json
  def create
    @project = @client.projects.new(project_params)

    if @project.save
      redirect_to home_path, notice: 'Project was successfully created'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    redirect_to home_path, notice: 'Project was successfully destroyed'
  end

  def home_path
    return admin_user_path(current_user) if current_user.admin?
    return user_path(current_user) if current_user.user?
    return manager_user_path(current_user) if current_user.manager?
  end

  private

  def set_client
    @client = Client.find(params[:client_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = @client.projects.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name, :client_id)
  end
end
