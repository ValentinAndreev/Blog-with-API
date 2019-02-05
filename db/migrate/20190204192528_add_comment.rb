class AddComment < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.datetime :published_at
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
