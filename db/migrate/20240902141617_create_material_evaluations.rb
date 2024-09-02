class CreateMaterialEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :material_evaluations do |t|
      t.references :user,     foreign_key: true
      t.references :material, foreign_key: true
      t.float :evaluation
      t.string :feature, default: ''
      
      t.timestamps
    end
  end
end
