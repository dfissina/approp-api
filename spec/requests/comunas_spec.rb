# spec/requests/comunas_spec.rb
require 'rails_helper'

RSpec.describe 'comunas API', type: :request do
  # initialize test data 
  let(:region) { create(:region) } 
  let(:region_id) { region.id }
  let!(:comunas) { create_list(:comuna, 4, region_id: region_id) }
  let(:comuna_id) { comunas.first.id }

  # Test suite for GET /comunas
  describe 'GET /comunas' do
    # make HTTP get request before each example
    before { get '/comunas' }

    it 'returns comunas' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /comunas/:id
  describe 'GET /comunas/:id' do
    before { get "/comunas/#{comuna_id}" }

    context 'when the record exists' do
      it 'returns the comunas' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(comuna_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:comuna_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Comuna/)
      end
    end
  end

  # Test suite for POST /comunas
  describe 'POST /comunas' do
    # valid payload
    let(:valid_attributes) { { name: 'Comuna 1', lat: 100, lng: 200, region_id: region.id } }
    
    context 'when the request is valid' do
      before { post '/comunas', params: valid_attributes }

      it 'creates a comuna' do
        expect(json['name']).to eq('Comuna 1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/comunas', params: { title: 'Comuna 1' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Region must exist, Name can't be blank, Lat can't be blank, Lng can't be blank/)
      end
    end
  end

  # Test suite for PUT /comunas/:id
  describe 'PUT /comunas/:id' do
    let(:valid_attributes) { { name: 'Comuna 2' } }

    context 'when the record exists' do
      before { put "/comunas/#{comuna_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /comunas/:id
  describe 'DELETE /comunas/:id' do
    before { delete "/comunas/#{comuna_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end