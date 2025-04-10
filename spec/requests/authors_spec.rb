require 'rails_helper'

RSpec.describe "Authors API", type: :request do
  describe "GET /authors" do
    it "returns a successful response" do
      # Create some authors in the database
      authors = FactoryBot.create_list(:author, 3)

      # Make the GET request
      get '/authors'

      # Expect a successful response
      expect(response).to have_http_status(:success)

      # Parse the JSON response
      json_response = JSON.parse(response.body)

      # Validate the response structure and data
      expect(json_response.size).to eq(authors.size)
      authors.each_with_index do |author, index|
        expect(json_response[index]["id"]).to eq(author.id)
        expect(json_response[index]["name"]).to eq(author.name)
      end
    end
  end
end
