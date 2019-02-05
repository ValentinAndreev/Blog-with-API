class AddPost < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.datetime :published_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
