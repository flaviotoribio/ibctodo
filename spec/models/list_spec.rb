require 'rails_helper'

RSpec.describe List, type: :model do
  # Association tests
  it { should belong_to(:board) }
  it { should have_many(:cards).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:name) }
end
