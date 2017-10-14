# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  
  # initialize test data
  let!(:users) { create_list(:user, 10) }
  let(:user) { users.first } 
  let(:user_id) { users.first.id }
  
  let(:valid_attributes) do
    attributes_for(:user, password_confirmation: user.password)
  end
  
  # authorize request
  let(:headers) { valid_headers }  
  
  # User signup test suite
  describe 'POST /signup' do
    
    # No se necesita HEADER[Authorization] para la accion signup 
    let(:headers) { valid_headers.except('Authorization') }
    
    context 'when valid request' do
        
      before { post '/signup', params: valid_attributes.to_json, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(201)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(422)
      end
       
      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, First name can't be blank, Last name can't be blank, Email can't be blank, Password digest can't be blank, Birth date can't be blank/)
      end
    end
  end
  
  # Test suite for GET /users
  describe 'GET /users' do
    # make HTTP get request before each example
    before { get '/users', params: {}, headers: headers }

    it 'returns users' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before { get "/users/#{user_id}", params: {}, headers: headers }

    context 'when the record exists' do
      it 'returns the user' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(user_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:user_id) { 0 }
      
      it 'returns status code 404' do
        
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find User/)
      end
    end
  end

  # Test suite for POST /users
#  describe 'POST /users' do
#    # valid payload
#    let(:valid_attributes) { { first_name: 'Jorge', last_name: 'Salcedo', email: 'jsalcedo@test.com', password_digest: 'vg5msvy1uerg7', birth_date: '01/01/1985', phone: '397.693.1309', cell_phone: '(186)285-7925' } }
#
#    context 'when the request is valid' do
#      before { post '/users', params: valid_attributes }
#
#      it 'creates a user' do
#        expect(json['first_name']).to eq('Jorge')
#      end
#
#      it 'returns status code 201' do
#        expect(response).to have_http_status(201)
#      end
#    end
#
#    context 'when the request is invalid' do
#      before { post '/users', params: valid_attributes }
#
#      it 'returns status code 422' do
#        expect(response).to have_http_status(422)
#      end
#
#      it 'returns a validation failure message' do
#        expect(response.body)
#          .to match(/Validation failed: Created by can't be blank/)
#      end
#    end
#  end

  # Test suite for PUT /users/:id
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { first_name: 'Test' }.to_json }

    context 'when the record exists' do
      before { put "/users/#{user_id}", params: valid_attributes, headers: headers }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  # Test suite for DELETE /users/:id
  describe 'DELETE /users/:id' do
    before { delete "/users/#{user_id}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end