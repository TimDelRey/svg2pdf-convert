class ExportInteraction < ApplicationInteraction
  object :record, class: ConversionRecord

  def execute
    # svg_path = ActiveStorage::Blob.service.send(:path_for, record.svg_file.key)
    return unless record.svg_file.attached?
    svg = record.svg_file.download

    Convertation::ConvertToPdf.call(record, svg)
  end
end