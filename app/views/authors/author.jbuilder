json.(@author, :name, :bio, :created_at, :updated_at)
json.books @author.books do |book|
  json.(book, :id, :title, :created_at, :updated_at)
end
