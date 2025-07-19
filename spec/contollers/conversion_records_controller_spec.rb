require 'rails_helper'
RSpec.describe ConversionRecordsController, type: :controller do
  let (:valid_svg) { fixture_file_upload(Rails.root.join('spec/fixtures/files/valid.svg'), 'image/svg+xml') }
  let (:invalid_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/not_svg.txt'), 'text/plain') }
  let (:ready_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/ready.pdf'), 'application/pdf') }

  let (:invalid_record) { FactoryBot.create(:conversion_record) }
  let (:valid_record) {
    record = FactoryBot.create(:conversion_record)
    record.pdf_file.attach(ready_file)
    record.save!
    record
  }

  subject(:upload_file) do
    ->(file) { post :create, params: { conversion_record: { svg_file: file } }, format: :json }
  end

  subject(:download_file) do
    ->(instance) { get :download, params: { id: instance.id } }
  end

  describe "POST #create" do
    context 'when valid svg.file' do
      it "returns http success" do
        upload_file.call(valid_svg)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when file has not svg format' do
      it 'created error log' do
        upload_file.call(invalid_file)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "download" do
    context 'when pdf is ready to download' do
      it "download is success" do
        download_file.call(valid_record)

        expect(response).to have_http_status(:ok)
        expect(response.header['Content-Type']).to eq('application/pdf')
        expect(response.body).to eq(valid_record.pdf_file.download)
      end
    end

    context 'when pdf dont ready and JS activate download button' do
      it 'created error log about trying download isnt ready pdf' do
        download_file.call(invalid_record)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "show" do
    context 'when pdf is ready' do
      it "show link to file" do
        get :show, params: { id: valid_record.id }, format: :json

        expect(response).to have_http_status(:ok)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to have_key('pdf_url')
      end
    end
  end
end
