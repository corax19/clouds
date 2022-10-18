json.extract! sip, :id, :sipid, :secret, :host, :number, :decription, :created_at, :updated_at
json.url sip_url(sip, format: :json)
