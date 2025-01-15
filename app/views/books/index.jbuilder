json.array! @books do |book|
  json.(book, :id, :title, :created_at, :updated_at)
end
