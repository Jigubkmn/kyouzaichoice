class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :commentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
