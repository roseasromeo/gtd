json.extract! checklist, :id, :name, :description, :user_id, :created_at, :updated_at
json.url checklist_url(checklist, format: :json)
