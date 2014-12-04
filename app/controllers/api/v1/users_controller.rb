class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :valid_sign?, only: [
    :show, :profile
  ]

  skip_before_action :valid_access_token?, only: [
    :show, :create
  ]

  before_action :set_user, only: [:show]

  # 获取用户信息
  # GET /users/:id
  def show
  end

  # 用户注册
  # POST /users
  def create
    @current_user = User.new(create_user_params)
    if @current_user.save
      @access_token = @current_user.set_access_token
      render 'profile', access_token: @access_token
    else
      render json: {msg: "用户注册失败！#{@current_user.errors.full_messages.join('；')}"}, status: 501
    end
  end

  # 获取登录用户信息
  # GET /profile/:access_token
  def profile
  end

  # 更新登录用户信息
  # PATCH /api/v1/profile/:access_token
  def profile_update
    if @current_user.update(update_user_params)
      render :profile
    else
      render json: {msg: "更新用户信息失败！#{@current_user.errors.full_messages.join('；')}"}, status: 501
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      begin
        @user = User.find params[:id]
      rescue Exception => e
        render json: {msg: "提供的用户ID无效！"}, status: 404
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_user_params
      begin
        params.require(:user).permit(:name, :e_mail, :password, :password_confirmation)
      rescue Exception => e
        {}
      end
    end

    def update_user_params
      begin
        params.require(:user).permit(:password, :password_confirmation)
      rescue Exception => e
        {}
      end
    end
end
