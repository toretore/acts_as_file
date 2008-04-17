require 'test/unit'
RAILS_ENV = "test"
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'acts_as_file_active_record_extensions'
require 'test/mock_model'
require 'fileutils'
require 'tempfile'

class ActsAsFileTest < Test::Unit::TestCase
  
  def teardown
    Dir.entries(File.join(File.dirname(__FILE__), 'uploads')).reject{|f|
      f =~ /^\.+$/
    }.each do |f|
      FileUtils.rm_f(File.join(File.dirname(__FILE__), 'uploads', f))
    end
  end
  
  def test_create_file_success
    File.open(File.join(File.dirname(__FILE__), 'tpb.jpg'), 'r') do |f|
      u = MockModel.new
      u.file = f
      u.filename = 'tpb.jpg'
      u.content_type = 'image/jpeg'
      assert u.save
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
    end
  end
  
  def test_create_file_failure_on_file
    u = MockModel.new
    u.filename = 'tpb.jpg'
    u.content_type = 'image/jpeg'
    assert !u.save
    assert !File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
    assert u.errors.on('file')
  end
  
  def test_create_file_failure_on_filename_missing
    File.open(File.join(File.dirname(__FILE__), 'tpb.jpg'), 'r') do |f|
      u = MockModel.new
      u.file = f
      u.content_type = 'image/jpeg'
      assert !u.save
      assert !File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
      assert u.errors.on('filename')
    end
  end
  
  def test_create_file_failure_on_filename_invalid
    File.open(File.join(File.dirname(__FILE__), 'tpb.jpg'), 'r') do |f|
      u = MockModel.new
      u.file = f
      u.filename = '../../../../../../danger/danger/high/voltage'
      u.content_type = 'image/jpeg'
      assert !u.save
      assert !File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
      assert u.errors.on('filename')
    end
  end
  
  def test_create_file_failure_on_filename_exists
    FileUtils.cp(File.join(File.dirname(__FILE__), 'tpb.jpg'), File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
    assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))

    File.open(File.join(File.dirname(__FILE__), 'tpb.jpg'), 'r') do |f|
      u = MockModel.new
      u.file = f
      u.filename = 'tpb.jpg'
      u.content_type = 'image/jpeg'
      assert !u.save
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
      assert u.errors.on('filename')
    end
  end
  
  def test_rename_file
    File.open(File.join(File.dirname(__FILE__), 'tpb.jpg'), 'r') do |f|
      u = MockModel.new
      u.file = f
      u.filename = 'tpb.jpg'
      u.content_type = 'image/jpeg'
      assert u.save
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
      
      #Simulate MockModel.find
      def u.new_record?; false; end
      u.file = nil
      u.send(:store_filename)
      assert(u.instance_variable_get('@previous_filename') == 'tpb.jpg')
      
      u.filename = 'tpb.png'
      u.content_type = 'image/png'
      assert u.send(:filename_changed?)
      assert u.save
      assert !File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.png'))
      
      u.send(:store_filename)
      assert(u.instance_variable_get('@previous_filename') == 'tpb.png')
      assert u.save
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.png'))
    end
  end
  
  def test_replace_file
    u = MockModel.new
      
    File.open(File.join(File.dirname(__FILE__), 'tpb.jpg'), 'r') do |f|
      u.file = f
      u.filename = 'tpb.jpg'
      u.content_type = 'image/jpeg'
      assert u.save
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
    end
      
    def u.new_record?; false; end
    u.file = nil
    u.send(:store_filename)
    assert(u.instance_variable_get('@previous_filename') == 'tpb.jpg')
    
    File.open(File.join(File.dirname(__FILE__), 'ishtar.png'), 'r') do |f|
      u.file = f
      u.filename = 'ishtar.png'
      u.content_type = 'image/png'
      assert u.save
      assert u.send(:filename_changed?)
      assert !File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'tpb.jpg'))
      assert File.exists?(File.join(File.dirname(__FILE__), 'uploads', 'ishtar.png'))
    end
  end
  
end
