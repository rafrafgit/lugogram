class AddImagelinkToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :imagelink, :string
  end
end
