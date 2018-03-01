class Registration < ApplicationRecord
  belongs_to :stage
  belongs_to :player
end
