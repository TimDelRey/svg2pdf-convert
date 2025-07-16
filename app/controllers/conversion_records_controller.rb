class ConversionRecordsController < ApplicationController
  def new
    @record = conversion_record.new
  end

  def create
    @record = Conversion_record.new(conversion_record_params)

    @document.save ? redirect_to download_document_path(@document) : render :new
  end

  def download
    receipt = Conversion_record.find(params[:id])
    if receipt.xls_file.attached?
      redirect_to url_for(receipt.xls_file)
    else
      head :not_found
    end
  end

  private

  def conversion_record_params
    params.permit(:id)
  end
end
