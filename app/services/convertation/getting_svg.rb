module Convertation
  class GettingSvg
    include Service
    
    def initalize(svg)
      @svg = svg
    end

    def call
      some_create_conversion_record_with_svg
    end

    private

    def some_create_conversion_record_with_svg
      @record = ConversionRecord.new
      @record.svg_file.attach(params[:conversion_record][:svg_file])
      @record.status = 'svg is loaded' if @record.svg_file.attached?

      if @record.save
        redirect_to new_conversion_record_path, notice: 'SVG uploaded successfully.'
      else
        flash.now[:alert] = 'Upload failed.'
        render :new
      end
    end
  end
end