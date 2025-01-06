class CompanyImporter
  BATCH_SIZE = 100

  def initialize(file)
    @file = file
  end

  def bulk_import
    imported_companies = []

    ActiveRecord::Base.transaction do
      CSV.foreach(@file.path, headers: true).each_slice(BATCH_SIZE) do |batch|
        batch.each do |row|
          company = process_row(row)
          imported_companies << company if company.persisted?
        end
      end
    end

    imported_companies
  rescue => error
    Rails.logger.error("Bulk import failed: #{error.message}")
    raise error
  end

  private

  def process_row(row)
    registration_number = row["registration_number"]
    company = Company.find_or_initialize_by(registration_number: registration_number)

    if company.new_record?
      create_company(company, row)
    else
      handle_duplicate(company, registration_number, row)
    end

    company
  end

  def create_company(company, row)
    company.name = row["name"]

    if company.save
      create_addresses(company, row)
    else
      raise ActiveRecord::RecordInvalid.new(company)
    end

    company
  end

  def create_addresses(company, row)
    company.addresses.create!(
      street: row["street"],
      city: row["city"],
      postal_code: row["postal_code"],
      country: row["country"]
    )
  rescue ActiveRecord::RecordInvalid => error
    log_error(error, row)
    raise error
  end

  def log_error(error, row)
    error_info = {
      registration_number: row["registration_number"],
      row_data: row.to_h,
      error_code: "validation_error"
    }

    error_response = ErrorHandler.handle(error, error_info)
    Rails.logger.error("Error importing #{row['name']}: #{error_response[:errors].join(', ')}")
  end

  def handle_duplicate(company, registration_number, row)
    Rails.logger.warn("Duplicate registration number #{registration_number} found for #{row['name']}. Skipping.")
  end
end
