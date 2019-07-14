class AllowedAppsController < ApplicationController

  before_action :set_allowed_app, only: [:destroy, :show, :edit, :update]
  before_action :set_app, only: [:index_app]
  before_action :set_user, only: [:index_user, :create]
  before_action :set_available_apps, only: [:index_user]

  before_action :set_fullpage, only: [:index_user, :index_app]

  def index_app
    @allowed_apps = @app.allowed_apps
  end

  def index_user
    @allowed_app = AllowedApp.new
  end

  def create
    @allowed_app =  @user.allowed_apps.build(allowed_app_params)
    if @allowed_app.valid?
      @allowed_app.save
      redirect_to user_allowed_apps_path(@user), notice: 'App was successfully added.'
    else
      @allowed_app.destroy
      render :index
    end
  end

  def update
    if @allowed_app.update(allowed_app_params)
      redirect_to allowed_app_path(@allowed_app), notice: 'Allowed app was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /allowed_apps/1
  # DELETE /allowed_apps/1.json
  def destroy

    @allowed_app.destroy
    redirect_back fallback_location: root_path
  end

  private

  def set_allowed_app
    @allowed_app = AllowedApp.find(params[:id])
    @user        = @allowed_app.user
    @app         = @allowed_app.app
  end

  def set_app
    @app = App.find(params[:app_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_available_apps
    @available_apps = App.where.not(id: @user.apps)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def allowed_app_params
    params.require(:allowed_app).permit(:app_id,:permissions)
  end
end
