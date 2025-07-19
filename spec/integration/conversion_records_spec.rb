require 'swagger_helper'

RSpec.describe 'ConversionRecords API', type: :request do
  let (:valid_svg) { fixture_file_upload(Rails.root.join('spec/fixtures/files/valid.svg'), 'image/svg+xml') }
  let (:invalid_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/not_svg.txt'), 'text/plain') }
  let (:ready_pdf_path) { fixture_file_upload(Rails.root.join('spec/fixtures/files/ready.pdf'), 'application/pdf') }

  let(:record_with_pdf) do
    FactoryBot.create(:conversion_record).tap do |r|
      r.pdf_file.attach(
        io: File.open(ready_pdf_path),
        filename: 'ready.pdf',
        content_type: 'application/pdf'
      )
      r.update!(status: 'PDF is ready')
    end
  end

  path '/conversion_records' do
    post 'Upload SVG and convert to PDF' do
      tags 'ConversionRecords'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :conversion_record, in: :formData, schema: {
        type: :object,
        properties: {
          svg_file: { type: :string, format: :binary }
        },
        required: ['svg_file']
      }

      response '200', 'SVG uploaded and PDF conversion started' do
        let(:conversion_record) { { svg_file: valid_svg } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to be_present
          expect(['svg is loaded', 'PDF is ready']).to include(data['status'])
        end
      end

      response '422', 'Invalid file format' do
        let(:conversion_record) { { svg_file: invalid_file } }
        run_test! do |response|
          expect(response.body).to include('Invalid SVG file')
        end
      end
    end
  end

  path '/conversion_records/{id}' do
    get 'Get PDF URL for a record' do
      tags 'ConversionRecords'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'PDF is ready' do
        let(:id) { record_with_pdf.id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['pdf_url']).to be_present
        end
      end

      response '404', 'PDF not ready yet' do
        let(:id) { FactoryBot.create(:conversion_record).id }
        run_test! do |response|
          expect(response.body).to include('PDF not ready')
        end
      end
    end
  end

  path '/conversion_records/{id}/download' do
    get 'Download the converted PDF' do
      tags 'ConversionRecords'
      produces 'application/pdf'
      parameter name: :id, in: :path, type: :string

      response '200', 'PDF downloaded' do
        let(:id) { record_with_pdf.id }
        run_test!
      end

      response '422', 'PDF conversion failed' do
        let(:id) { FactoryBot.create(:conversion_record).id }
        run_test! do |response|
          expect(response.body).to include('PDF conversion failed')
        end
      end
    end
  end
end
