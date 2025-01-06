require 'rails_helper'
require 'csv'

RSpec.describe CompanyImporter do
  describe "#bulk_import" do
    let(:file) { Rails.root.join('spec/fixtures/test_companies.csv') }

    before do
      CSV.open(file, 'w') do |csv|
        csv << ['registration_number', 'name', 'street', 'city', 'postal_code', 'country']
        csv << [123456, 'Test Company', '123 Main St', 'Anytown', '12345', 'USA']
        csv << [789012, 'Another Company', '456 Elm St', 'Othertown', '', 'USA']
        csv << [123456, 'Duplicate Company', '789 Oak St', 'Anytown', '67890', 'USA']
      end
    end

    after do
      File.delete(file) if File.exist?(file)
    end

    it "imports companies from CSV successfully" do
      importer = CompanyImporter.new(file)

      expect {
        importer.bulk_import
      }.to change(Company, :count).by(2)

      expect(Company.last.name).to eq('Another Company')
    end

    it "logs a warning for duplicate registration numbers" do
      importer = CompanyImporter.new(file)

      expect(Rails.logger).to receive(:warn).with(/Duplicate registration number 123456 found for Duplicate Company. Skipping./)

      importer.bulk_import
    end

    it "handles errors during import gracefully" do
      CSV.open(file, 'w') do |csv|
        csv << ['registration_number', 'name', 'street', 'city', 'postal_code', 'country']
        csv << [nil, '', '', '', '', '']
      end

      importer = CompanyImporter.new(file)

      expect {
        importer.bulk_import
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect(Company.count).to eq(0)
    end
  end
end
