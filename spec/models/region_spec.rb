require 'rails_helper'

RSpec.describe Region, type: :model do
  # Validation tests
  it { should have_many(:comunas) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:lat) }
  it { should validate_presence_of(:lng) }
end
