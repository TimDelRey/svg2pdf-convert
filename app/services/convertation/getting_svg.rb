module Convertation
  class GettingSvg
    include Service

    def initialize(svg)
      @svg = svg
    end

    def call
      raise ArgumentError, 'Files format error' unless @svg.content_type == 'image/svg+xml'

      record = ConversionRecord.new
      record.svg_file.attach(@svg)
      record.status = 'svg is loaded' if record.svg_file.attached?
      record.save
      record
    end
  end
end
