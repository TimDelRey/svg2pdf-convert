class ConversionRecordsController < ApplicationController
  def new
    @record = ConversionRecord.new
  end

  def create
    @record = Convertation::GettingSvg.call(params[:conversion_record][:svg_file])

    # if @record.persisted?
    #   redirect_to new_conversion_record_path(id: @record.id), notice: 'SVG uploaded successfully.'
    # else
    #   flash.now[:alert] = 'Upload failed.'
    #   render :new, status: :unprocessable_entity
    # end
  end


  def export
    Convertation::ConvertToPdf.call(@new_record.id)
    Convertation::DownloadPdf.call(@new_record.id)
  end

  private

  def conversion_record_params
    params.permit(:id)
  end
end
