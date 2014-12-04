result = {
  user: {
    name: @current_user.name,
    e_mail: @current_user.e_mail
  }
}

result = result.merge({access_token: @access_token}) if @access_token

result.to_json
