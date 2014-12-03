class Api::V1::BaseController < Api::BaseController
  skip_before_action :valid_sign?, only: [
    :welcome
  ]
  
  def welcome
    render :json => {:say => "hello world !"}
  end
end
