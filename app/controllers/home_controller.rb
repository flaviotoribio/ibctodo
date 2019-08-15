class HomeController < ApplicationController
  def index
    # TODO: Temporary
    @board = current_user.boards.first
    @lists = @board.lists
  end
end
