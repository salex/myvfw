json.extract! user, :id, :type, :email, :username, :full_name, :password, :password_confirmatin, :roles, :reset_token, :post, :district, :department, :created_at, :updated_at
json.url user_url(user, format: :json)
