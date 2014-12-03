class Api::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :valid_sign?
  before_action :valid_access_token?, only: [:exchange_access_token]

  # 获取全局的 access_token
  # 提供 用户账号、密码 获取对应的 access_token
  # access_token 具有时效性，暂定 1 周的有效期
  def get_access_token
    begin
      user = User.find_by(name: params[:user_account]).authenticate(params[:user_password])
      if user
        # 用户账号、密码验证通过，设置 access_token cache
        token = rand_token
        Rails.cache.write([:access_token, token], user.id, :expires_in => 1.week)
        render json: {access_token: token}, status: 200
      else
        raise
      end
    rescue Exception => e
      Rails.logger.info "-#{Time.now}: Action -> get_access_token Error -> #{e}"
      render json: {msg: "错误的用户或者密码！"}, status: 401
    end
  end

  # 通过已有的 access_token 换取新的 access_token
  def exchange_access_token
    token = rand_token
    Rails.cache.write([:access_token, token], @current_user.id, :expires_in => 1.week)
    Rails.cache.delete [:access_token, params[:access_token]]
    render json: {access_token: token}, status: 200
  end

  # 验证全局的 access_token 是否有效
  def valid_access_token?
    begin
      @current_user = User.find Rails.cache.read([:access_token, params[:access_token]])
    rescue Exception => e
      Rails.logger.info "-#{Time.now}: Action -> valid_access_token? Error -> #{e}"
      render json: {msg: "提供 access_token 无效！"}, status: 403
    end
  end

  private
  # 生成随机字符串
  def rand_token
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.times do
      token = ""
      1.upto(20) { |i| token << chars[rand(chars.size-1)] }
      redo if Rails.cache.read([:access_token, token])
      return token
    end
  end

  # 验证全局的sign
  def valid_sign?
    # 校验时间戳
    # 请求携带的 timestamp 系统当前时间比较，相差超过10秒直接返回请求过期
    if (Time.now.to_i - params[:timestamp].to_i > 10) && (Rails.env == "production")
      render json: {msg: "请求已过期，无法响应！"}, status: 401
    else
      str_arr = []
      params.each{|k, v| str_arr << "#{k}=#{v}" unless ["action", "controller", "sign"].include? k}
      str = "#{str_arr.sort.join("&")}#{SECRET_TOKEN}"
      unless Digest::SHA1.hexdigest(str) == params[:sign]
        render json: {msg: "签名校验失败！"}, status: 401
      end
    end
  end
end
