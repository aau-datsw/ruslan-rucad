class CreateServers < ActiveRecord::Migration[5.2]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :ip
      t.integer :port
      t.integer :tv_port
      t.string :server_password
      t.string :rcon_password

      t.timestamps
    end

    add_index :servers, :ip
    add_index :servers, :port
    add_index :servers, :tv_port
  end
end
