require 'spec_helper'

describe Member do
  before do
    @user_1 = create_user name: 'Sub1', email: '1@1.com'
    @user_2 = create_user name: 'Sub2', email: '2@2.com'
    @user_3 = create_user name: 'NonSub', email: '3@3.com'
    SubscriptionEvent.create!(
      user: @user_1,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: @user_2,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: @user_2,
      event_type: 'changed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 500,
    )
    SubscriptionEvent.create!(
      user: @user_3,
      event_type: 'unsubscribed',
      date: Date.today.beginning_of_month - 6.months,
      price_per_month_in_cents: 0,
    )
    SubscriptionEvent.create!(
      user: @user_3,
      event_type: 'subscribed',
      date: Date.today.beginning_of_month - 7.months,
      price_per_month_in_cents: 700,
    )
    SubscriptionEvent.create!(
      user: @user_3,
      event_type: 'unsubscribed',
      date: Date.today.beginning_of_month - 8.months,
      price_per_month_in_cents: 0,
    )
  end
  it 'can filter current members' do
    members = Member.new
    expect(members.filter_current(User.all)).to eq ([@user_1, @user_2])
  end
end