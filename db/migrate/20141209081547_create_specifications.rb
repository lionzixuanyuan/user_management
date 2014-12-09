class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.references :creater, index: true
      t.string :brand
      t.string :model
      t.string :pdf

      t.timestamps
    end
  end
end
