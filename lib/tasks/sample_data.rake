namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  admin = User.create!(name: "Lugogram Staff",
                         email: "lugogram@gmail.com", 
                         password: "bajen01",
                         password_confirmation: "bajen01")
    admin.toggle!(:admin)
    
  end
end