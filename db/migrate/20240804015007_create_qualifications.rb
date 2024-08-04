class CreateQualifications < ActiveRecord::Migration[7.0]
  def change
    create_table :qualifications do |t|
      t.references :user, foreign_key: true
      t.string :name,             null: false
      t.string :progress,         null: false
      t.integer :year_acquired
      t.timestamps
    end
  end
end
