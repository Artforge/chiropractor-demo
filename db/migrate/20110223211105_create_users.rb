class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :name
      t.text :biography
      t.date :date_of_birth
      t.string :favorite_color

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
