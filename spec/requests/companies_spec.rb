require 'rails_helper'

RSpec.describe "Companies API", type: :request do
  describe "POST /companies" do
    let(:valid_attributes_single_address) do
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

    let(:valid_attributes_multiple_addresses) do
      {
        company: {
          name: "Multi Address Company",
          registration_number: 789012,
          addresses_attributes: [
            { street: "123 Main St", city: "Anytown", postal_code: "12345", country: "USA" },
            { street: "456 Elm St", city: "Othertown", postal_code: "54321", country: "USA" }
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

    it "creates a company with a single address" do
      expect {
        post "/api/v1/companies", params: valid_attributes_single_address
      }.to change(Company, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Test Company")
      expect(JSON.parse(response.body)["addresses"]).to be_present
      expect(JSON.parse(response.body)["addresses"].size).to eq(1)
    end

    it "creates a company with multiple addresses" do
      expect {
        post "/api/v1/companies", params: valid_attributes_multiple_addresses
      }.to change(Company, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["name"]).to eq("Multi Address Company")
      expect(JSON.parse(response.body)["addresses"]).to be_present
      expect(JSON.parse(response.body)["addresses"].size).to eq(2)
    end

    it "does not create a company with invalid attributes" do
      post "/api/v1/companies", params: invalid_attributes

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
    end
  end
end
