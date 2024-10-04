class AddBodyToMaterialEvaluations < ActiveRecord::Migration[7.0]
  def change
    add_column :material_evaluations, :body, :text
  end
end
