class ChangePublishedDateMaterials < ActiveRecord::Migration[7.0]
  def change
    change_column_null :materials, :published_date, true
  end
end
