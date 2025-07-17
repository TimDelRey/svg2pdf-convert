class ConversionRecordsController < ApplicationController
  def new
    @record = ConversionRecord.new
  end

  def create
    @record = Convertation::GettingSvg.call(params[:conversion_record][:svg_file])

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


  def export
    @record = ConversionRecord.find(params[:id])
    updated_record = ExportInteraction.run(record: @record)

    if @record.pdf_file.attached?
      send_data @record.pdf_file.download,
                filename: @record.pdf_file.filename.to_s,
                type: 'application/pdf',
                disposition: 'inline'
    else
      render json: { message: 'PDF conversion failed.' }, status: :unprocessable_entity
    end

    # @outcome = ::ExportInteraction.run(@record)
    
    # if outcome.valid?
    #   # Convertation::DownloadPdf.call(@record.id)
    #   outcome.pdf_file.download
    # else
    #   render json: {message: outcome.error_message}, status: :unprocessable_entity
    # end
  end

  private

  def conversion_record_params
    params.permit(:id)
  end
end
