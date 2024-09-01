class CreateMaterialEvalution < ActiveRecord::Migration[7.0]
  def change
    create_table :material_evalutions do |t|

      t.timestamps
    end
  end
end
