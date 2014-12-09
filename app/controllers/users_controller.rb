class UsersController < ApplicationController
  before_action :require_log_in, only: [:index, :show]
  # before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @page_title = "用户列表"
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by(:name => params[:user_name]) or not_found
    @page_title = "#{@current_user.name}"
    render layout: "with_left_nav"
  end

  # GET /users/new
  def new
    @page_title = "注册"
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    puts ">>>>>"
    puts ">>>>>"
    p @current_user
    puts ">>>>>"
    puts ">>>>>"
    @page_title = "编辑"
    render layout: 'with_left_nav'
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(create_user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to account_path(@user.name), notice: '注册成功！' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:by] == "pwd" && !@current_user.authenticate(params[:user][:current_password])
      @current_user.errors.add(:password, "：旧密码不正确！")
    end

    respond_to do |format|
      if @current_user.errors.empty? && @current_user.update(update_user_params)
        format.html { redirect_to account_path(@current_user.name), notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', layout: 'with_left_nav' }
        format.json { render json: @current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_user
    #   @user = User.find params[:id]
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_user_params
      params.require(:user).permit(:name, :e_mail, :password, :password_confirmation)
    end

    def update_user_params
      if params[:by] == "pwd"
        params.require(:user).permit(:password, :password_confirmation)
      else
        params.require(:user).permit()
      end
    end
end
