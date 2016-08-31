class CreatePorts < ActiveRecord::Migration[5.0]
  def change
    create_table :ports do |t|
      t.references :host, foreign_key: true
      t.string :name
      t.boolean :shutdown
      t.string :vrf
      t.string :vlan
      t.string :ipaddr
      t.string :netmask
      t.string :description
      t.boolean :configured

      t.timestamps
    end
  end
end
