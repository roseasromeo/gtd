json.extract! item, :id, :name, :description, :belongs_to, :created_at, :updated_at
json.url item_url(item, format: :json)
