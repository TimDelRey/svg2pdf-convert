module Convertation
  class GettingSvg
    include Service
    
    def initialize(svg)
      @svg = svg
    end

    def call
      record = ConversionRecord.new
      record.svg_file.attach(@svg)
      record.status = 'svg is loaded' if record.svg_file.attached?
      record.cropping_fields = false
      record.watermark = false
      record.save
      record
    end
  end
end