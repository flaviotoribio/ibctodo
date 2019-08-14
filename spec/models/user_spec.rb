require 'rails_helper'

RSpec.describe User, type: :model do
  # Association tests
  it { should have_many(:boards).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
end
