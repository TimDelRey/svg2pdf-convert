require 'swagger_helper'

RSpec.describe 'ConversionRecords API', type: :request do
  path '/conversion_records' do
    post 'Upload SVG, create & convert to PDF' do
      tags 'Conversion'
      consumes 'multipart/form-data'
      parameter name: :conversion_record, in: :formData, schema: {
        type: :object,
        properties: {
          svg_file: { type: :string, format: :binary }
        },
        required: ['svg_file']
      }

      response '200', 'SVG uploaded and PDF created' do
        schema type: :object, properties: { id: { type: :integer }, status: { type: :string } }, required: ['id']

        let(:svg_file) { fixture_file_upload('spec/fixtures/test.svg', 'image/svg+xml') }
        let(:conversion_record) { { svg_file: svg_file } }

        run_test!
      end

      response '422', 'invalid request' do
        let(:conversion_record) { { svg_file: nil } }
        run_test!
      end
    end
  end

  path '/conversion_records/{id}' do
    get 'Get PDF URL' do
      tags 'Conversion'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'pdf url returned' do
        schema type: :object, properties: { pdf_url: { type: :string, format: :uri } }, required: ['pdf_url']

        let(:id) { ConversionRecord.create(...).tap { |r| /* attach a pdf_file */ }.id }
        run_test!
      end

      response '404', 'not found or not ready' do
        let(:id) { 0 }
        run_test!
      end
    end
  end

  path '/conversion_records/{id}/download' do
    get 'Download PDF' do
      tags 'Conversion'
      produces 'application/pdf'
      parameter name: :id, in: :path, type: :integer

      response '200', 'pdf is downloaded' do
        let(:id) { ConversionRecord.create(...).tap { |r| r.pdf_file.attach(io: File.open('spec/fixtures/test.pdf'), filename: 't.pdf') }.id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
