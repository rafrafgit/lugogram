class AddWeblinkToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :weblink, :string
  end
end
