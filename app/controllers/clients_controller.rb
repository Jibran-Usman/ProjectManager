# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients = if params[:name]
                 Client.where('name LIKE ?', "%#{params[:name]}%").page(params[:page])
               else
                 Client.page(params[:page])
               end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @projects = if params[:name]
                  @client.projects.where('name LIKE ?', "%#{params[:name]}%").page(params[:page])
                else
                  @client.projects.page(params[:page])
                end
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to home_path, notice: 'Client was successfully created'
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    if @client.update(client_params)
      redirect_to home_path, notice: 'Client successfully updated'
    else
      render :edit
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    redirect_to home_path, notice: 'Client was successfully destroyed'
  end

  def home_path
    return admin_user_path(current_user) if current_user.admin?
    return user_path(current_user) if current_user.user?
    return manager_user_path(current_user) if current_user.manager?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:name, :affiliation)
  end
end
