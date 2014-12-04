class Api::V1::BaseController < Api::BaseController
  skip_before_action :valid_sign?, only: [
    :welcome
  ]

  skip_before_action :valid_access_token?, only: [
    :welcome
  ]
  
  # Hello Word ！
  # GET /api/v1/base/welcome
  def welcome
    render :json => {:say => "hello world !"}
  end
end
