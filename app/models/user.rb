class User < ActiveRecord::Base
  has_secure_password
  has_many :subscription_events

  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :name, presence: true, uniqueness: {case_sensitive: false}

  def lifetime_value
    lifetime_value = 0
    events = subscription_events.order(:date)

    events.each_with_index do |starting_event, i|
      starting_date = starting_event.date
      ending_date = if events[i + 1].nil?
                      Date.today
                    else
                      events[i + 1].date
                    end
      lifetime_value += value_for_date_range(
        months_between(ending_date, starting_date),
        starting_event.price_per_month_in_cents
      )
    end

    Money.new(lifetime_value, "USD")
  end

  def value_for_date_range(number_of_months, price_per_month)
    price_per_month * number_of_months
  end

  def months_between(ending_date, starting_date)
    (ending_date.month - starting_date.month) + 12 * (ending_date.year - starting_date.year)
  end

end
