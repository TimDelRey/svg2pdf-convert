require 'rails_helper'

RSpec.describe "ConversionRecords", type: :controller do
  describe "GET /new" do
    it "returns http success" do
      get "/conversion_records/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/conversion_records/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /download" do
    it "returns http success" do
      get "/conversion_records/download"
      expect(response).to have_http_status(:success)
    end
  end
end
