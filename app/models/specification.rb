class Specification < ActiveRecord::Base
  belongs_to :creater, :class_name => "User", :foreign_key => "creater_id"

  validates_presence_of :brand, :message => "：品牌不能为空！"
  validates_presence_of :model, :message => "：型号不能为空！"

  mount_uploader :pdf, PdfUploader
end
