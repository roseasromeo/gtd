json.extract! task, :id, :project_id, :location_id, :name, :description, :time, :energy, :completed, :created_at, :updated_at
json.url task_url(task, format: :json)
