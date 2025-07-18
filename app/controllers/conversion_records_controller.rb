class ConversionRecordsController < ApplicationController
  rescue_from ArgumentError, with: :handle_invalid_svg

  def new
    @record = ConversionRecord.new
  end

  def create
    @record = Convertation::GettingSvg.call(params[:conversion_record][:svg_file])

    if @record.persisted?
      Convertation::ConvertToPdf.call(@record)
      render json: { id: @record.id, status: @record.status }
    else
      render json: { message: 'NOT svg' }, status: :unprocessable_entity
    end
  end


  def download
    @record = ConversionRecord.find(params[:id])
    if @record.pdf_file.attached?
      send_data @record.pdf_file.download,
                filename: "converted_#{@record.id}.pdf",
                type: 'application/pdf',
                disposition: 'attachment'
    else
      render json: { message: 'PDF conversion failed' }, status: :unprocessable_entity
    end
  end

  def show
    @record = ConversionRecord.find(params[:id])

    if @record.pdf_file.attached?
      render json: { pdf_url: url_for(@record.pdf_file) }
    else
      render json: { error: 'PDF not ready' }, status: :not_found
    end
  end

  private

  def handle_invalid_svg(exception)
    Rails.logger.error("Invalid SVG file: #{exception.message}")
    respond_to do |format|
      format.json { render json: { message: 'Invalid SVG file' }, status: :unprocessable_entity }
    end
  end
end
