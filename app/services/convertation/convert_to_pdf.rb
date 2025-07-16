module Convertation
  class ConvertToPdf
    include Service

    def initalize(id)
      @id = id
    end

    def call
      some_create_fealds_logic
      some_create_watermark_logic
      some_create_pdf_logic
      some_create_conversion_record_logic

      record = Conversion_record.find(@id)
      if record.xls_file.attached?
        redirect_to url_for(record.xls_file)
      else
        head :not_found
      end
    end
  end