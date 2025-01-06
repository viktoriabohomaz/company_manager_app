class ErrorHandler
  def self.handle(error, error_info = {})
    Rails.logger.error("Error occurred: #{error.message}")

    response = {
      message: error.message,
      errors: error.respond_to?(:full_messages) ? error.full_messages : [ error.message ]
    }

    response.merge!(error_info) if error_info.present?

    response
  end
end
