json.(@book, :id, :title, :created_at, :updated_at)
json.author @book.author
json.synopses @book.synopses
json.current_synopsis @book.synopses&.first
