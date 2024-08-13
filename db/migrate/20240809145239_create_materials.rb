class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :title,         null: false
      t.string :image_link,    null: false
      t.date :published_date,  null: false
      t.timestamps
    end
  end
end
