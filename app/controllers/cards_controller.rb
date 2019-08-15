class CardsController < ApiController
  before_action :set_board_list

  def index
    @cards = @list.cards
    render json: @cards, status: :ok
  end

  def show
    @card = @list.cards.find(params[:id])
    render json: @card, status: :ok
  end

  def create
    @card = @list.cards.new(card_params)
    if @card.save
      if params['return_block'].blank?
        render json: @card, status: :created
      else
        render partial: 'home/card_blocks', locals: { board: @board, list: @list, cards: [@card] }
      end
    else
      if params['return_block'].blank?
        render json: { errors: @card.errors,
                       full_message: @card.errors.full_messages },
                       status: :unprocessable_entity
      else
        render partial: 'home/card_blocks' # fix
      end
    end
  end

  def update
    @card = @list.cards.find(params[:id])
    if @card.update_attributes(card_params)
      render json: @card, status: :ok
    else
      render json: { errors: @card.errors,
                     full_message: @card.errors.full_messages },
                     status: :unprocessable_entity
    end
  end

  def destroy
    @card = @list.cards.find(params[:id])
    @card.destroy
    head :no_content
  end

  private

  def set_board_list
    @board = current_user.boards.find(params[:board_id])
    @list = @board.lists.find(params[:list_id])
  end

  def card_params
    params.permit(:text, :position)
  end
end
