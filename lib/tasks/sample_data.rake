namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  admin = User.create!(name: "Lugogram Staff",
                         email: "lugogram@gmail.com",
                         avatar: "http://lugogram.com/images/ninja-avatar-48x48.png",
                         password: "bajen01",
                         password_confirmation: "bajen01")
    admin.toggle!(:admin)
    
  end
end