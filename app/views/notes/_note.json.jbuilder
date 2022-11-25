json.extract! note, :id, :subject, :body, :user_id, :client_id, :created_at, :updated_at
json.url note_url(note, format: :json)
