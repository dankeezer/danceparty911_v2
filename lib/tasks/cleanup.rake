desc "Delete all Guest Users"
task :cleanup => :environment do
  p "Destroying Guest Users..."
  User.where(username: "guest").destroy_all
  p "Complete"
end
