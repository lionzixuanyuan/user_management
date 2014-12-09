class User < ActiveRecord::Base
  has_secure_password
  
  validates_presence_of :name, :message => "：用户名不能为空！"
  validates_length_of :name, :maximum => 20, :message => "：用户名长度不得长于20位字母或数字！"
  validates_uniqueness_of :name,:case_sensitive => false, :message => "：该用户名已存在！"
  validates_format_of :e_mail, :message => "：邮箱格式不正确！", :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of :e_mail,:case_sensitive => false, :message => "：该邮箱已存在！"

  scope :show_params, -> {select(:name, :e_mail)}

  # 为用户设置对应的 access_token
  def set_access_token
    access_token_present = Rails.cache.read([:access_token_present, self.id])
    if access_token_present
      Rails.cache.delete [:access_token, access_token_present]
    end
    token = User.rand_token
    Rails.cache.write([:access_token, token], self.id, :expires_in => 1.week)
    if Rails.env == "production"
      Rails.cache.write([:access_token_present, self.id], token, :expires_in => 1.day)
    else
      Rails.cache.write([:access_token_present, self.id], token, :expires_in => 60.second)
    end
    token
  end

  private
  # 生成随机字符串
  def self.rand_token
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    1.times do
      token = ""
      1.upto(20) { |i| token << chars[rand(chars.size-1)] }
      redo if Rails.cache.read([:access_token, token])
      return token
    end
  end
end
