class Member
  def filter_current(users_list)
    users_list.map { |member| member if active?(member) }.compact
  end

  def active?(member)
    last_event = member.subscription_events.sort_by { |event| event[:date] }.last
    true if last_event && last_event[:event_type] != "unsubscribed"
  end
end