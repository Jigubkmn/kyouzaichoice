class DropMaterialEvaluationsTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :material_evaluations
  end
end
