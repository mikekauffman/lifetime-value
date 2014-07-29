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
      if subscription_events.length == 1
        start_date = subscription_events[i].date
        end_date = Date.today.beginning_of_month
        duration = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
        lifetime_value += (subscription_events[i].price_per_month_in_cents * duration)
      else
        sorted = subscription_events.sort { |a, b| a.date <=> b.date }
        if sorted[i].event_type != "unsubscribed"
          if sorted[i + 1] != nil
            start_date = sorted[i].date
            end_date = sorted[i + 1].date
            duration = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
            lifetime_value += (sorted[i].price_per_month_in_cents * duration)
          else
            start_date = sorted[i].date
            end_date = Date.today.beginning_of_month
            duration = (end_date.year * 12 + end_date.month) - (start_date.year * 12 + start_date.month)
            lifetime_value += (sorted[i].price_per_month_in_cents * duration)
          end
        else
          lifetime_value += 0
        end
      end
      i += 1
    end
    Money.new(lifetime_value, "USD")
  end

  def active_months(event)
    if event.event_type == "unsubscribed"
      0
    else
      Date.today.beginning_of_month
      event.date
    end
  end
end
