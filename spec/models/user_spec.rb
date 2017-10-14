require 'rails_helper'

# Test suite for User model
RSpec.describe User, type: :model do
    # Association test
    # ensure User model has a 1:m relationship with the Property model
    it { should have_many(:properties) }
    # Validation tests
    # ensure first_name, last_name, email, birth_date and password are present before save
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:password_digest) }
end
