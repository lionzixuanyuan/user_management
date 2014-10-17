json.array!(@users) do |user|
  json.extract! user, :id, :user_name, :e_mail, :hashed_password
  json.url user_url(user, format: :json)
end
