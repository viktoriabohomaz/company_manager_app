module Api::V1
  class CompaniesController < ApplicationController
    def index
      companies = Company.includes(:addresses).all
      render json: companies.as_json(include: :addresses), status: :ok
    end

    def create
      company = Company.new(company_params)

      if company.save
        render json: company, status: :created
      else
        render json: ErrorHandler.handle(company.errors), status: :unprocessable_entity
      end
    end

    def bulk_import
      if params[:file].present?
        importer = CompanyImporter.new(params[:file])

        begin
          imported_companies = importer.bulk_import
          render json: imported_companies.as_json(include: :addresses), status: :ok
        rescue => error
          handle_import_error(error)
        end
      else
        render json: { error: "No file provided" }, status: :bad_request
      end
    end

    def show
      company = Company.find(params[:id])
      render json: company.as_json(include: :addresses), status: :ok
    rescue ActiveRecord::RecordNotFound => error
      render json: ErrorHandler.handle(error), status: :not_found
    end

    private

    def company_params
      params.require(:company).permit(:name, :registration_number, addresses_attributes: [ :street, :city, :postal_code, :country ])
    end

    def handle_import_error(error)
      error_response = ErrorHandler.handle(error)
      Rails.logger.error("Import failed: #{error_response[:message]}")
      render json: error_response, status: :unprocessable_entity
    end
  end
end
