class AddTokenToUser < ActiveRecord::Migration
  def change
  	add_column :users, :device_token, :text
  end
end
