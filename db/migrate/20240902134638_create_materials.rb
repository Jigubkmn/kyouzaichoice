class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :title        , null: false
      t.string :image_link
      t.date :published_date
      t.text :info_link
      t.string :systemid

      t.timestamps
    end
  end
end
