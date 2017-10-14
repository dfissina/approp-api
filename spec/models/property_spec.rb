require 'rails_helper'

RSpec.describe Property, type: :model do
    # Association test
    # ensure a property record belongs to a single user record
    it { should belong_to(:user) }
    it { should belong_to(:comuna) }
    # Validation test
    # ensure column name is present before saving
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:bedrooms) }
    it { should validate_presence_of(:bathrooms) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:build_mtrs) }
    it { should validate_presence_of(:total_mtrs) }
    it { should validate_presence_of(:property_type) }
    it { should validate_presence_of(:operation) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:currency) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:show_pin_map) }
    it { should validate_presence_of(:condominium) }
    it { should validate_presence_of(:furniture) }
    it { should validate_presence_of(:orientation) }
    it { should validate_presence_of(:pets) }
end
