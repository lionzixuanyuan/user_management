class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :have_current_user?
  before_action :require_log_in, only: :log_out

  # 尝试获取当前登陆用户
  def have_current_user?
    @current_user = User.find session[:user_id] if session[:user_id]
  end

  # 判断用户登录状态
  def require_log_in
    redirect_to log_in_form_path unless @current_user
  end

  # 登录表单
  def log_in_form
    @page_title = "登录"
  end

  # 登录
  def log_in
    @current_user = User.find_by(name: params[:user_account]).authenticate(params[:user_password]) rescue @current_user = false
    if @current_user
      session[:user_id] = @current_user.id
      redirect_to account_path(@current_user.name)
    else
      flash[:notice] = "用户名或者密码错误！"
      redirect_to log_in_form_path 
    end
  end

  # 登出
  def log_out
    session[:user_id] = nil
    redirect_to root_path
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
