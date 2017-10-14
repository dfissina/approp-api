require 'rails_helper'

RSpec.describe 'Properties API' do
  # Initialize the test data
  let(:user) { create(:user) }
  let(:region) { create(:region) }
  let(:comuna) { create(:comuna, region_id: region.id) }
  let!(:properties) { create_list(:property, 20, user_id: user.id, comuna_id: comuna.id) }
  let(:user_id) { user.id }
  let(:id) { properties.first.id }
  let(:headers) { valid_headers }
 
  # Test suite for GET /users/:user_id/properties
  describe 'GET /users/:user_id/properties' do
    before { get "/users/#{user_id}/properties", params: {}, headers: headers }

    context 'when user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all user properties' do
        expect(json.size).to eq(20)
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for GET /users/:user_id/properties/:id
  describe 'GET /users/:user_id/properties/:id' do
    before { get "/users/#{user_id}/properties/#{id}", params: {}, headers: headers }

    context 'when user property exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the property' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when user property does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Property/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/properties
  describe 'POST /users/:user_id/properties' do
    
    let(:valid_attributes) { { 
      title: 'Property test.', 
      description: 'Casa en arriendo en Santiago.', 
      bedrooms: 2, 
      bathrooms: 1, 
      price: 100000, 
      build_mtrs: 200, 
      total_mtrs: 200, 
      property_type: 'casa', 
      operation: 'arriendo', 
      state: 'usada', 
      currency: 'clp', 
      street: '47 street', 
      number: 800, 
      neighborhood: 'Estadio Nacional', 
      show_pin_map: true,
      comuna_id: 1,
      condominium: true,
      furniture:  true,
      orientation: 'norte',
      pets: true
    }.to_json }
      
    context 'when request attributes are valid' do
      before do
        post "/users/#{user_id}/properties", params: valid_attributes, headers: headers 
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      before { post "/users/#{user_id}/properties", params: {}, headers: headers }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to match(/Validation failed: Comuna must exist/)
      end
    end
  end

  # Test suite for PUT /users/:user_id/properties/:id
  describe 'PUT /users/:user_id/properties/:id' do
    let(:valid_attributes) { { title: 'Nueva casa en venta' }.to_json }

    before do
      put "/users/#{user_id}/properties/#{id}", params: valid_attributes, headers: headers 
    end

    context 'when property exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'updates the property' do
        updated_property = Property.find(id)
        expect(updated_property.title).to match(/Nueva casa en venta/)
      end
    end

    context 'when the property does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Property/)
      end
    end
  end

  # Test suite for DELETE /users/:user_id/properties/:id
  describe 'DELETE /users/:user_id/properties/:id' do
    before { delete "/users/#{user_id}/properties/#{id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
