class ConversionRecordsController < ApplicationController
  def new
    @record = ConversionRecord.new
  end

  def create
    @new_record = Convertation::CreatePdf.call(params[:id])
  end

  def export
    Convertation::Dowload.call(@new_record.id)
  end

  private

  def conversion_record_params
    params.permit(:id)
  end
end
