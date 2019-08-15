class BoardsController < ApiController
  def index
    @boards = current_user.boards.includes(:lists)
    render json: @boards, status: :ok
  end

  def show
    @board = current_user.boards.find(params[:id])
    render json: @board, status: :ok
  end

  def create
    @board = current_user.boards.new(board_params)
    if @board.save
      render json: @board, status: :created
    else
      render partial: 'home/list_blocks' # fix
    end
  end

  def update
    @board = current_user.boards.find(params[:id])
    if @board.update_attributes(board_params)
      render json: @board, status: :ok
    else
      render json: { errors: @board.errors,
                     full_message: @board.errors.full_messages },
                     status: :unprocessable_entity
    end
  end

  def destroy
    @board = current_user.boards.find(params[:id])
    @board.destroy
    head :no_content
  end

  private

  def board_params
    params.permit(:name, :position)
  end
end
