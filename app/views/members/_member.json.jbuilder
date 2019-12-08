json.extract! member, :id, :vfw_id, :first_name, :mi, :last_name, :full_name, :phone, :address, :city, :state, :zip, :status, :email, :type_pay, :pay_year, :pay_status, :pay_date, :country, :paid_thru, :days_remaining, :last_status, :served, :alt_phone, :created_at, :updated_at
json.url member_url(member, format: :json)
