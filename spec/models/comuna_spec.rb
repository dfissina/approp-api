require 'rails_helper'

RSpec.describe Comuna, type: :model do
  # Validation tests
  it { should belong_to(:region) }
  it { should have_many(:properties) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:lat) }
  it { should validate_presence_of(:lng) }
end
