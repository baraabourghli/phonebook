class AddFullnameAndNumberToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :full_name, :string
    add_column :contacts, :number, :string
    add_index :contacts, :number, unique: true
  end
end
