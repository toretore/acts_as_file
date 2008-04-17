
#http://www.bigbold.com/snippets/posts/show/767
ActiveRecord::Base.class_eval do
  alias_method :save, :valid?
  def self.columns() @columns ||= []; end
  
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end
end

class MockModel < ActiveRecord::Base
  
  def self.validates_uniqueness_of(foo)
    nil
  end

  column :content_type, :string
  column :filename, :string
  column :original_filename, :string
  column :size, :integer

  acts_as_file
  
  self.save_path = File.join(File.dirname(__FILE__), 'uploads')
  

end