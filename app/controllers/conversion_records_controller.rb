class ConversionRecordsController < ApplicationController
  def new
    @record = ConversionRecord.new
  end

  def create
    @record = ConversionRecord.new(conversion_record_params)

    if @document.save
      redirect_to download_document_path(@document)
    else
      render :new
    end
  end

  def export
    record = Convertation::CreatePdf.call(params[:id])
    Convertation::Dowload.call([record.id])
  end

  private

  def conversion_record_params
    params.permit(:id)
  end
end
