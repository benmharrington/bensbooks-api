json.array! @authors do |author|
  json.(author, :name, :bio, :created_at, :updated_at)
end
