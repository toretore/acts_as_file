require 'fileutils'
require 'acts_as_file_active_record_extensions'
ActiveRecord::Base.send(:include, FleskPlugins::ActsAsFile::ActiveRecordExtensions)