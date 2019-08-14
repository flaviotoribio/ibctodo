require 'rails_helper'

RSpec.describe Board, type: :model do
  # Association tests
  it { should belong_to(:user) }
  it { should have_many(:lists).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:name) }
end
