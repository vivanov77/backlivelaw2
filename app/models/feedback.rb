class Feedback < ApplicationRecord  
  belongs_to :user, optional: true, :inverse_of => :feedbacks
end
