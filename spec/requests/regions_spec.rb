# spec/requests/regions_spec.rb
require 'rails_helper'

RSpec.describe 'Regions API', type: :request do
  # initialize test data 
  let!(:regions) { create_list(:region, 4) }
  let(:region_id) { regions.first.id }

  # Test suite for GET /regions
  describe 'GET /regions' do
    # make HTTP get request before each example
    before { get '/regions' }

    it 'returns regions' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /regions/:id
  describe 'GET /regions/:id' do
    before { get "/regions/#{region_id}" }

    context 'when the record exists' do
      it 'returns the regions' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(region_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:region_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Region/)
      end
    end
  end

  # Test suite for POST /regions
  describe 'POST /regions' do
    # valid payload
    let(:valid_attributes) { { name: 'Region 1', lat: 100, lng: 200 } }

    context 'when the request is valid' do
      before { post '/regions', params: valid_attributes }

      it 'creates a region' do
        expect(json['name']).to eq('Region 1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/regions', params: { title: 'Region 1' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /regions/:id
  describe 'PUT /regions/:id' do
    let(:valid_attributes) { { name: 'Region 2' } }

    context 'when the record exists' do
      before { put "/regions/#{region_id}", params: valid_attributes }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /regions/:id
  describe 'DELETE /regions/:id' do
    before { delete "/regions/#{region_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end