class MessageContact < ApplicationRecord
  #alias_attribute :sender_user, :user
  belongs_to :user
  belongs_to :property
end
