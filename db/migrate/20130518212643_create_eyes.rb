class CreateEyes < ActiveRecord::Migration
  def change
    create_table :eyes do |t|
      t.integer :micropost_id
      t.integer :user_id

      t.timestamps
    end

    add_index :eyes, :micropost_id
    add_index :eyes, :user_id

  end
end
