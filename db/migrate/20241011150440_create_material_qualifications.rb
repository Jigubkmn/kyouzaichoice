class CreateMaterialQualifications < ActiveRecord::Migration[7.0]
  def change
    create_table :material_qualifications do |t|
      
      t.references :material, foreign_key: true
      t.references :qualification, foreign_key: true
      t.timestamps
    end
  end
end
