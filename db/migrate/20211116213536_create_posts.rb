class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :link, limit: 256
      t.string :image, limit: 256
      t.string :title, limit: 256
      t.text :text, limit: 5000

      t.timestamps
    end
  end
end
