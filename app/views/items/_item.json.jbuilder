json.extract! item, :id, :name, :content, :belongs_to, :created_at, :updated_at
json.url item_url(item, format: :json)
