class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :password, :update_password, :reset_user_key]
  before_action :set_fullpage, only: [:index]


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params_update)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def password
  end

  def update_password
    respond_to do |format|
      if @user.update(user_params_password)
        format.html { redirect_to @user, notice: 'User password was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_user_key
    @user.reset_user_key
    redirect_to @user, notice: 'User Key was successfully updated.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :enabled, :email)
    end

    def user_params_update
      params.require(:user).permit(:name, :enabled)
    end
    
    def user_params_password
      params.permit(:password)
    end
end
