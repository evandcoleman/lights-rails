desc "Send a silent push to schedule the sunset notification"
task :update_feed => :environment do
  puts "Send sunset silent push"
  User.all.each do |user|
    user.device_tokens.each do |token|
      notification = Houston::Notification.new(device: token)
      notification.content_available = true
      notification.custom_data = {event: "schedule_sunset"}
      APN.push(notification)
    end
  end
end