require 'rails_helper'

RSpec.describe Property, type: :model do
    # Association test
    # ensure a property record belongs to a single user record
    it { should belong_to(:user) }
    # Validation test
    # ensure column name is present before saving
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:bedrooms) }
    it { should validate_presence_of(:bathrooms) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:build_mtrs) }
    it { should validate_presence_of(:total_mtrs) }
end
