class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.references :user,     foreign_key: true
      t.references :material, foreign_key: true
      t.float :evaluation
      t.string :feature, default: ''

      t.timestamps
    end
  end
end
