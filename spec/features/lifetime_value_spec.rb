require 'spec_helper'

feature 'Lifetime value' do
  before do
    user_1 = create_user name: 'Sub1', email: '10@10.com'
    user_2 = create_user name: 'Sub2', email: '20@20.com'
    user_3 = create_user name: 'NonSub', email: '30@30.com'
    SubscriptionEvent.create!(
      user: user_1,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: user_2,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: user_2,
      event_type: 'changed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 500,
    )
    SubscriptionEvent.create!(
      user: user_3,
      event_type: 'unsubscribed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 0,
    )
    SubscriptionEvent.create!(
      user: user_3,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
  end
  scenario 'Users are displayed with their lifetime value' do
    visit root_path
    fill_in "Email", with: "10@10.com"
    fill_in "Password", with: "password"
    click_on "Login"
    click_on 'Lifetime Value'
    expect(page).to have_content '$49.00'
    expect(page).to have_content '$37.00'
    expect(page).to have_content '$7.00'
  end
end