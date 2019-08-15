class HomeController < ApplicationController
  def index
    @boards = current_user.boards
  end

  def board
    @board = current_user.boards.find(params[:id])
    @lists = @board.lists
  end
end
