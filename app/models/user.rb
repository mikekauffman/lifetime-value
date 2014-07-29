class User < ActiveRecord::Base
  has_secure_password
  has_many :subscription_events

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  def lifetime_value
    i = 0
    lifetime_value = 0
    subscription_events
    while i < subscription_events.length
      sorted = subscription_events.sort { |a, b| a.date <=> b.date }
      start_date = sorted[i].date
      if sorted.length == 1 || sorted[i + 1] == nil
        end_date = Date.today.beginning_of_month
      else
        end_date = sorted[i + 1].date
      end
      duration = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
      lifetime_value += (sorted[i].price_per_month_in_cents * duration)
      i += 1
    end
    Money.new(lifetime_value, "USD")
  end

end
