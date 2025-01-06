require 'rails_helper'

RSpec.describe "Companies API", type: :request do
  describe "POST /companies" do
    let(:valid_attributes) do
      {
        company: {
          name: "Test Company",
          registration_number: 123456,
          addresses_attributes: [
            { street: "123 Main St", city: "Anytown", postal_code: "12345", country: "USA" }
          ]
        }
      }
    end

    let(:invalid_attributes) do
      {
        company: {
          name: "",
          registration_number: nil,
          addresses_attributes: []
        }
      }
    end

    it "creates a company with addresses" do
      expect {
        post "/api/v1/companies", params: valid_attributes
      }.to change(Company, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Test Company")
    end

    it "does not create a company with invalid attributes" do
      post "/api/v1/companies", params: invalid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
    end
  end
end
