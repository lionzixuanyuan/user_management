class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :e_mail
      t.string :hashed_password

      t.timestamps
    end
  end
end
