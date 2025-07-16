class ConversionRecordsController < ApplicationController
  def new
    @record = ConversionRecord.new
  end

  def create
    @new_record = Convertation::GettingSvg.call(params[:id])
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
