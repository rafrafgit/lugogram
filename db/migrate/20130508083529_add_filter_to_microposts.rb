class AddFilterToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :filter, :string
  end
end
