require 'rails_helper'
RSpec.describe Convertation::GettingSvg, type: :service do
  let(:valid_svg) { fixture_file_upload(Rails.root.join('spec/fixtures/files/valid.svg'), 'image/svg+xml') }
  let(:invalid_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/not_svg.txt'), 'text/plain') }

  describe 'Selecting a file to download' do
    context 'when file is valid SVG' do
      it 'creates instance of ConversionRecord with attached svg_file' do
        service = described_class.new(valid_svg)
        record = service.call

        expect(record).to be_persisted
        expect(record.svg_file).to be_attached
        expect(record.status).to eq('svg is loaded')
      end
    end

    context 'when file is not SVG' do
      it 'raises ArgumentError' do
        expect {
          described_class.new(invalid_file).call
        }.to raise_error(ArgumentError, 'Files format error')
      end
    end
  end
end
