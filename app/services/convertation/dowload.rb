module Convertation
  class Download
    include Service
    
    def initalize(id)
      @id = id
    end

    def call
      record = Conversion_record.find(@id)
      if record.xls_file.attached?
        redirect_to url_for(record.xls_file)
      else
        head :not_found
      end
    end
  end