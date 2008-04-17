class Create<%= class_name %> < ActiveRecord::Migration
  def self.up
    create_table '<%= table_name %>' do |t|
      t.column :title, :string
      t.column :body, :text
      t.column :filename, :string
      t.column :original_filename, :string
      t.column :content_type, :string
      t.column :size, :integer
      
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
    end
  end

  def self.down
    drop_table '<%= table_name %>'
  end
end