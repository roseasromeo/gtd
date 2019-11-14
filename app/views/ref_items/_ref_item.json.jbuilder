json.extract! ref_item, :id, :name, :description, :folder_id, :created_at, :updated_at
json.url ref_item_url(ref_item, format: :json)
