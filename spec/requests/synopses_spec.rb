require 'rails_helper'

RSpec.describe "Synopses", type: :request do
  describe "GET /synopses" do
    it "returns a successful response" do
      get synopses_path
      expect(response).to have_http_status(:success)
    end
  end
end
