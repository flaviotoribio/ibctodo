require 'rails_helper'

RSpec.describe 'Lists API', type: :request do
  before do
    @user = create(:user)
    sign_in @user
  end

  let!(:board) { create(:board, user_id: @user.id) }
  let!(:lists) { create_list(:list, 10, board_id: board.id) }
  let(:board_id) { board.id }
  let(:list_id) { lists.first.id }

  describe 'GET /boards/:board_id/lists' do
    before { get "/boards/#{board_id}/lists" }

    it 'returns lists' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /boards/:board_id/lists/:id' do
    before { get "/boards/#{board_id}/lists/#{list_id}" }

    context 'when the record exists' do
      it 'returns the list' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(list_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:list_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find List/)
      end
    end
  end

  describe 'POST /boards/:board_id/lists' do
    let(:valid_attributes) { { name: 'Test 1' } }

    context 'when the request is valid' do
      before { post "/boards/#{board_id}/lists", params: valid_attributes }

      it 'creates a list' do
        expect(json['name']).to eq('Test 1')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end
  end

  describe 'PUT /boards/:board_id/lists/:id' do
    let(:valid_attributes) { { name: 'Test 2' } }

    context 'when the record exists' do
      before { put "/boards/#{board_id}/lists/#{list_id}", params: valid_attributes }

      it 'updates the record' do
        expect(json['name']).to eq('Test 2')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'DELETE /boards/:board_id/lists/:id' do
    before { delete "/boards/#{board_id}/lists/#{list_id}" }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end

  # TODO: more relational tests with Board (check if board exists etc.)
end
