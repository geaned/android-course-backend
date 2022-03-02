class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :user_name, limit: 32
      t.string :first_name, limit: 64
      t.string :last_name, limit: 64
      t.string :picture, limit: 256
      t.string :about_me, limit: 200
      t.string :email, limit: 64
      t.string :phone_number, limit: 32
      t.string :password, limit: 64

      t.timestamps
    end
  end
end
