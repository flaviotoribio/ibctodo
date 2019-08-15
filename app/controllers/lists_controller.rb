class ListsController < ApiController
  before_action :set_board

  def index
    @lists = @board.lists.includes(:cards)
    render json: @lists, status: :ok
  end

  def show
    @list = @board.lists.includes(:cards).find(params[:id])
    render json: @list, status: :ok
  end

  def create
    @list = @board.lists.new(list_params)
    if @list.save
      if params['return_block'].blank?
        render json: @list, status: :created
      else
        render partial: 'home/list_blocks', locals: { board: @board, lists: [@list] }
      end
    else
      if params['return_block'].blank?
        render json: { errors: @list.errors,
                       full_message: @list.errors.full_messages },
                       status: :unprocessable_entity
      else
        render partial: 'home/list_blocks' # fix
      end
    end
  end

  def update
    @list = @board.lists.includes(:cards).find(params[:id])
    if @list.update_attributes(list_params)
      render json: @list, status: :ok
    else
      render json: { errors: @list.errors,
                     full_message: @list.errors.full_messages },
                     status: :unprocessable_entity
    end
  end

  def destroy
    @list = @board.lists.find(params[:id])
    @list.destroy
    head :no_content
  end

  private

  def set_board
    @board = current_user.boards.find(params[:board_id])
  end

  def list_params
    params.permit(:name, :position)
  end
end
