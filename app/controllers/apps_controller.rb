class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy, :reset_app_key, :reset_rsa_key_pair]
  before_action :set_fullpage, only: [:index]
  
  # GET /apps
  # GET /apps.json
  def index
    @apps = App.all
  end

  # GET /apps/1
  # GET /apps/1.json
  def show
  end

  # GET /apps/new
  def new
    @app = App.new(timeout: ENV.fetch("DEFAULT_TOKEN_TIMEOUT") { 86400 })
  end

  # GET /apps/1/edit
  def edit
  end

  # POST /apps
  # POST /apps.json
  def create
    @app = App.new(app_params)

    respond_to do |format|
      if @app.save
        format.html { redirect_to @app, notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apps/1
  # PATCH/PUT /apps/1.json
  def update
    respond_to do |format|
      if @app.update(app_params)
        format.html { redirect_to @app, notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @app }
      else
        format.html { render :edit }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  def destroy
    @app.destroy
    if @app.errors.any?
      redirect_to apps_url, alert: @app.errors.full_messages.join(', ')
    else
      redirect_to apps_url, notice: 'App was successfully destroyed.'
    end
  end

  def reset_app_key
    @app.reset_app_key
    redirect_to @app, notice: 'App Key was successfully updated.'
  end

  def reset_rsa_key_pair
    @app.reset_rsa_key_pair
    redirect_to @app, notice: 'JWT Secret was successfully updated.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app
      @app = App.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.require(:app).permit(:name, :permissions, :timeout)
    end
end
