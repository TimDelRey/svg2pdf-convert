require 'nokogiri'

module Convertation
  class ConvertToPdf
    include Service

    WATERMARK = ENV.fetch('WATERMARK', '')
    LEFT_FIELD = ENV.fetch('LEFT_FIELD', 0).to_i
    RIGHT_FIELD = ENV.fetch('RIGHT_FIELD', 0).to_i
    TOP_FIELD = ENV.fetch('TOP_FIELD', 0).to_i
    BOTTOM_FIELD = ENV.fetch('BOTTOM_FIELD', 0).to_i

    def initialize(record)
      @record = record
      @svg = record.svg_file.download
    end

    def call
      Tempfile.create(['converted', '.pdf']) do |file|
        create_tempfile_pdf(file)

        file.rewind

        connect_pdf_to_record(file)
        @record
      end
    end

    private

    def create_tempfile_pdf(file)
      Prawn::Document.generate(file.path, margin: [TOP_FIELD, RIGHT_FIELD, BOTTOM_FIELD, LEFT_FIELD]) do |pdf|
        width, height = scaled_svg_dimensions(pdf)

        x = (pdf.bounds.width - width) / 2
        y = pdf.bounds.top

        pdf.svg(@svg, at: [x, y], width: width, height: height)
        added_watermark(pdf)

        # для отображения границ
        # pdf.stroke_color 'ff0000'
        # pdf.stroke_bounds
      end

      @record.update(cropping_fields: true)
    end

    def connect_pdf_to_record(file)
      @record.pdf_file.attach(
        io: file,
        filename: "converted_#{@record.id}.pdf",
        content_type: 'application/pdf'
      )
      @record.update(status: 'PDF is ready')
    end

    def added_watermark(pdf)
      pdf.fill_color '999999'
      pdf.draw_text WATERMARK, at: [100, 400], size: 30, rotate: 45
      @record.update(watermark: true)
    end

    def scaled_svg_dimensions(pdf)
      svg_width, svg_height = svg_dimensions(@svg)

      max_width  = pdf.bounds.width
      max_height = pdf.bounds.height

      scale = [max_width / svg_width, max_height / svg_height].min

      [svg_width * scale, svg_height * scale]
    end

    def svg_dimensions(svg_content)
      doc = Nokogiri::XML(svg_content)
      svg = doc.at_css('svg')
      width = svg['width']&.to_f
      height = svg['height']&.to_f

      if width.nil? || height.nil?
        view_box = svg['viewBox']
        if view_box
          _, _, w, h = view_box.split.map(&:to_f)
          width ||= w
          height ||= h
        end
      end

      width ||= 100
      height ||= 100

      [width, height]
    end
  end
end
