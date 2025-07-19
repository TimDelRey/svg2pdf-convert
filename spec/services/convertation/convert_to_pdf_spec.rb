require 'rails_helper'

RSpec.describe Convertation::ConvertToPdf, type: :service do
  let(:valid_svg) { fixture_file_upload(Rails.root.join('spec/fixtures/files/valid.svg'), 'image/svg+xml') }
  let(:record) { FactoryBot.create(:conversion_record) }

  subject(:service) { described_class.new(record) }

  describe 'converting svg to pdf' do
    it 'attaches a PDF file to the record' do
      result = service.call

      expect(result).to eq(record)
      expect(result.pdf_file).to be_attached
    end

    it 'sets correct status and flags' do
      service.call
      record.reload

      expect(record.status).to eq('PDF is ready')
      expect(record.cropping_fields).to eq(true)
      expect(record.watermark).to eq(true)
    end
  end
end
