json.array! @books do |book|
  json.(book, :id, :title, :created_at, :updated_at)
  json.author @author do |author|
    json.(author, :id, :name, :created_at, :updated_at)
  end
end
