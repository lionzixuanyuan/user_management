class User < ActiveRecord::Base
  has_secure_password
  
  validates_presence_of :name, :message => "：用户名不能为空！"
  validates_length_of :name, :maximum => 20, :message => "：用户名长度不得长于20位字母或数字！"
  validates_uniqueness_of :name,:case_sensitive => false, :message => "：该用户名已存在！"
  validates_format_of :e_mail, :message => "：邮箱格式不正确！", :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of :e_mail,:case_sensitive => false, :message => "：该邮箱已存在！"
end
