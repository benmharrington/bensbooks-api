json.array! @authors do |author|
  json.(author, :id, :name, :bio, :created_at, :updated_at)
end
