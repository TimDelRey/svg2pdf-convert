class ExportInteraction < ApplicationInteraction
  object :record, class: ConversionRecord

  def execute
    # svg_path = ActiveStorage::Blob.service.send(:path_for, record.svg_file.key)
    return unless record.svg_file.attached?

    Convertation::ConvertToPdf.call(record)
  end
end