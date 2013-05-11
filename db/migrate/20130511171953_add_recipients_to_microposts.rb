class AddRecipientsToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :recipients, :string
  end
end
