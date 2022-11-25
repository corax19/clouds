json.extract! client, :id, :firstname, :lastname, :phone1, :phone2, :phone3, :idnum, :country, :city, :address, :email, :birthday, :created_at, :updated_at
json.url client_url(client, format: :json)
