class CreateHosts < ActiveRecord::Migration[5.0]
  def change
    create_table :hosts do |t|
      t.string :hostname
      t.string :connect
      t.string :username
      t.string :password
      t.string :enable_password

      t.timestamps
    end
  end
end
