require 'rails_helper'

RSpec.describe 'Boards API', type: :request do
  before do
    @user = create(:user)
    sign_in @user
  end

  let!(:boards) { create_list(:board, 10, user_id: @user.id) }
  let(:board_id) { boards.first.id }

  describe 'GET /boards' do
    before { get '/boards' }

    it 'returns boards' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /boards/:id' do
    before { get "/boards/#{board_id}" }

    context 'when the record exists' do
      it 'returns the board' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(board_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:board_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Board/)
      end
    end
  end

  describe 'POST /boards' do
    let(:valid_attributes) { { name: 'Test 1', user_id: @user.id } }

    context 'when the request is valid' do
      before { post '/boards', params: valid_attributes }

      it 'creates a board' do
        expect(json['name']).to eq('Test 1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /boards/:id' do
    let(:valid_attributes) { { name: 'Test 2' } }

    context 'when the record exists' do
      before { put "/boards/#{board_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['name']).to eq('Test 2')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /boards/:id' do
    before { delete "/boards/#{board_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
