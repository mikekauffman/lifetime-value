require 'spec_helper'

feature 'Interacting with a list of users' do
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
    SubscriptionEvent.create!(
      user: user_3,
      event_type: 'unsubscribed',
      date: Date.today.beginning_of_month - 8.months,
      price_per_month_in_cents: 0,
    )
  end
  scenario 'A list of users can be displayed' do
    visit root_path
    fill_in "Email", with: "10@10.com"
    fill_in "Password", with: "password"
    click_on "Login"
    click_on 'Current Members'
    expect(page).to_not have_content 'Sub3'
    expect(page).to have_content 'Sub1'
    expect(page).to have_content 'Sub2'
  end
end