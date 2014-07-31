require 'rails_helper'

describe User do
  let(:user) { create_user }

  it 'can determine lifetime value of a currently subscribed user' do
    SubscriptionEvent.create!(
      user: user,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )

    expect(user.lifetime_value).to eq '$49.00'
  end

  it 'can determine the lifetime value of a user who has changed their subscription' do
    SubscriptionEvent.create!(
      user: user,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: user,
      event_type: 'changed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 500,
    )

    expect(user.lifetime_value).to eq '$37.00'
  end

  it 'can determine the lifetime value of a user who has changed their subscription twice' do
    SubscriptionEvent.create!(
      user: user,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 8.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: user,
      event_type: 'changed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 600,
    )
    SubscriptionEvent.create!(
      user: user,
      event_type: 'changed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 500,
    )

    expect(user.lifetime_value).to eq '$43.00'
  end

  it 'can determine the lifetime value of a user who has unsubscribed' do
    SubscriptionEvent.create!(
      user: user,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: user,
      event_type: 'unsubscribed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 0,
    )

    expect(user.lifetime_value).to eq '$7.00'
  end
end