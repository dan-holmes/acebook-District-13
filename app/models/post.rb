class Post < ApplicationRecord
    belongs_to :user

    def formatted_message
      self.message.gsub(/\n/, '<br/>').html_safe
    end

    def editable?(current_user_id)
      owned_by?(current_user_id) && is_less_than_ten_minutes_old?
    end

    def owned_by?(current_user_id)
      current_user_id == self.user_id
    end
    
    def is_less_than_ten_minutes_old?
      self.created_at + 10.minutes > DateTime.now()
    end
end
