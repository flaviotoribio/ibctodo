require 'rails_helper'

RSpec.describe Card, type: :model do
  # Association tests
  it { should belong_to(:list) }

  # Validation tests
  it { should validate_presence_of(:text) }
end
