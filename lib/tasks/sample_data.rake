namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  admin = User.create!(name: "Staff",
                         email: "lugogram@gmail.com",
                         avatar: "/images/ninja-avatar-48x48.png",
                         password: "bajen01",
                         password_confirmation: "bajen01")
    admin.toggle!(:admin)
    
  end
end