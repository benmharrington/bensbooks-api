json.array! @synopses do |synopsis|
  json.(synopsis, :id, :content, :created_at, :updated_at)
  json.user synopsis.user
  json.book synopsis.book
end
