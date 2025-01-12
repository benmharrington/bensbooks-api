json.array! @books do |book|
  json.(book, :id, :name, :created_at, :updated_at)
end
