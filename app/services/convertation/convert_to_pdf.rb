module Convertation
  class ConvertToPdf
    include Service

    WATERMARK = ENV.fetch('WATERMARK')
    LEFT_FIELD = ENV.fetch('LEFT_FIELD')
    RIGHT_FIELD = ENV.fetch('RIGHT_FIELD')
    TOP_FIELD = ENV.fetch('TOP_FIELD')
    BOTTOM_FIELD = ENV.fetch('BOTTOM_FIELD')

    def initialize(record, svg)
      @record = record
      @svg = svg
    end

    def call
      Tempfile.create(['converted', '.pdf']) do |file|
        Prawn::Document.generate(file.path, margin: [TOP_FIELD, RIGHT_FIELD, BOTTOM_FIELD, LEFT_FIELD]) do |pdf|
          added_watermark(pdf)
          pdf.svg(@svg, at: [0, pdf.cursor], width: 500)
        end

        file.rewind

        connect_pdf_to_record(file)
        @record
      end
    end

    private

    def added_watermark(pdf)
      pdf.fill_color '999999'
      pdf.draw_text WATERMARK, at: [100, 400], size: 30, rotate: 45
    end

    def connect_pdf_to_record(file)
      @record.pdf_file.attach(
        io: file,
        filename: "converted_#{@record.id}.pdf",
        content_type: 'application/pdf'
      )
    end
  end
end