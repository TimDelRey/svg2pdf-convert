module Convertation
  class Download
    include Service
    
    def initalize(svg)
      @svg = svg
    end

    def call
      some_create_fealds_logic
      some_create_watermark_logic
      some_create_pdf_logic
      some_create_conversion_record_logic
    end
  end
end