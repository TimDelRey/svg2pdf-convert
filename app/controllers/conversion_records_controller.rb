class ConversionRecordsController < ApplicationController
  def new
    @record = ConversionRecord.new
  end


  def create
    @record = Convertation::GettingSvg.call(params[:conversion_record][:svg_file])
    Convertation::ConvertToPdf.call(@record) if @record.persisted?

    respond_to do |format|
      if @record.persisted?
        format.json { render json: { id: @record.id, status: @record.status } }
        format.html { redirect_to new_conversion_record_path(id: @record.id), notice: 'SVG uploaded successfully.' }
      else
        format.json { render json: { errors: @record.errors.full_messages }, status: :unprocessable_entity }
        format.html { render :new, status: :unprocessable_entity }
      end
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
end
