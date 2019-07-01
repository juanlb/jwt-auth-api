# frozen_string_literal: true

class AllowedAppsController < ApplicationController
  before_action :set_allowed_app, only: [:destroy, :show, :edit, :permissions]
  before_action :set_user, only: [:index, :create, :destroy, :show, :edit, :permissions]
  before_action :set_available_apps, only: [:index, :create]

  # GET /allowed_apps
  # GET /allowed_apps.json
  def index
    @allowed_apps = @user.allowed_apps
    @allowed_app = AllowedApp.new
  end

  def create
    @allowed_app =  AllowedApp.new(allowed_app_params)
    @allowed_app.user = @user
    if @allowed_app.save
      redirect_to user_allowed_apps_path(@user), notice: 'App was successfully added.'
    else
      render :index
    end
  end

  def permissions
    if @allowed_app.update(allowed_app_params)
      redirect_to user_allowed_app_path(@user, @allowed_app), notice: 'Allowed app was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /allowed_apps/1
  # DELETE /allowed_apps/1.json
  def destroy
    @allowed_app.destroy
    redirect_to user_allowed_apps_path(@user), notice: 'Allowed app was successfully destroyed.'
  end

  private

  def set_available_apps
    @available_apps = App.where.not(id: @user.apps)
  end

  def set_allowed_app
    @allowed_app = AllowedApp.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def allowed_app_params
    params.require(:allowed_app).permit(:app_id,:permissions)
  end
end
