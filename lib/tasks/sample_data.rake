namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  admin = User.create!(name: "Lugogram Staff",
                         email: "lugogram@gmail.com",
                         avatar: "https://i0.wp.com/api.heroku.com/images/v3/profile/ninja-avatar-48x48.png?ssl=1",
                         password: "bajen01",
                         password_confirmation: "bajen01")
    admin.toggle!(:admin)
    
  end
end