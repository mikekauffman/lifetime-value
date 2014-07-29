class Member
  def filter_current(users_list)
    current_users = users_list.map { |member| member if active?(member) }.compact
    current_users.sort_by { |user| user[:name]}
  end

  def active?(member)
    last_event = member.subscription_events.sort_by { |event| event[:date] }.last
    true if last_event && last_event[:event_type] != "unsubscribed"
  end
end