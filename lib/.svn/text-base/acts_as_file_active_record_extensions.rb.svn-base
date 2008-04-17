module FleskPlugins#:nodoc:
  module ActsAsFile#:nodoc:
  
    #This module extends ActiveRecord.
    #
    #<tt>ClassMethods</tt> are added to all model classes.
    #<tt>SingletonMethods</tt> are added to all model classes containing <tt>acts_as_file</tt>.
    #<tt>InstanceMethods</tt> are added to all models of classes containing <tt>acts_as_file</tt>.
    module ActiveRecordExtensions#
    
      ActsAsFileError = Class.new(StandardError)
  
      def self.included(base)#:nodoc:
        base.send(:extend, ClassMethods)
      end
  
      module ClassMethods
      
      
        def acts_as_file
          raise(ActsAsFileError, 'Your model must contain the column "filename"') unless column_names.include?('filename')
          include InstanceMethods
          extend SingletonMethods
          @save_path ||= File.join(RAILS_ROOT, 'public', 'uploads')
          @read_path ||= 'uploads'
          attr_accessor :file
          after_find :store_filename
          before_validation :check_filename, :check_filename_changed, :write_file
          after_destroy :delete_file
        end
        
        
      end
      
      
      #Methods in this module are added to the model class
      module SingletonMethods
        
        
        #This is the path that will be presented to the browser
        def read_path
          @read_path
        end
        
        
        def read_path=(path)
          @read_path = path
        end
        
        
        #This is the path on the server where files will
        #be saved. The file's own path() will be added to it.
        def save_path
          @save_path
        end
        
        
        def save_path=(path)
          @save_path = path
        end
      
      
      end
      
      
      #Methods in this module are added as instance methods to the model class.
      module InstanceMethods
      
        FILENAME_REGEX = /^[^\/\\]+$/
        
        
        #The path from which the browser can read the file. It is
        #by default a copy of <tt>read_path</tt> on the model
        #class.
        def read_path
          @read_path ||= self.class.read_path.dup
        end
        
        
        def read_path=(new_path)
          @read_path = new_path
        end
        
        
        #The path where the file will be saved. This is
        #by default a copy of <tt>save_path</tt> on the
        #model class.
        def save_path
          @save_path ||= self.class.save_path.dup
        end
        
        
        def save_path=(new_path)
          @save_path = new_path
        end
        
        
        #This file's own path. Blank by default, but can
        #be overridden if necessary. Will be appended to
        #<tt>save_path</tt>.
        def path
          ''
        end
        
        
        def save_path_with_own_path
          File.join(save_path, path)
        end
        
        
        def save_path_with_filename
          File.join(save_path_with_own_path, filename)
        end
        
        
        def read_path_with_own_path
          File.join(read_path, path)
        end
        
        
        def read_path_with_filename
          File.join(read_path_with_own_path, filename)
        end
        
        
        def url
          '/'+read_path_with_filename
        end
        
        
        protected
        
          #Dummy to trigger store_filename after_find.
          #Can safely be overwritten, but not undefined.
          def after_find#:nodoc:
          end
        
        
        private
          
        
          #Store this file's filename in case it's changed
          def store_filename
            @previous_filename = self.filename.dup
          end
          
          
          def filename_changed?
            self.filename != @previous_filename
          end
          
        
          def check_filename
            if filename.blank?
              if file.respond_to?(:original_filename) && !file.original_filename.blank?
                self.filename = file.original_filename
              else
                errors.add('filename', 'is required')
                return false
              end
            end
            
            unless filename =~ FILENAME_REGEX
              errors.add('filename', 'contains invalid characters')
              return false
            end
            
            if new_record? && File.exists?(save_path_with_filename)
              errors.add('filename', 'already exists')
              return false
            end
          end
          
          
          def check_filename_changed
            return true if new_record? || !self.file.nil?
            
            if filename_changed?
              File.rename(File.join(save_path, path, @previous_filename), save_path_with_filename)
            end
          rescue
            errors.add('filename', 'could not be changed')
            return false
          else
            return true
          end
          
        
          def write_file
            
            if !self.file || (self.file.respond_to?(:length) && self.file.length == 0)
              if new_record?
                errors.add('file', 'is missing')
                return false
              else
                return true
              end
            end
            
            %w(original_filename size content_type).each do |method|
              if self.file.respond_to?(method) && self.respond_to?(method+'=')
                self.send(method+'=', self.file.send(method))
              end
            end
            
            FileUtils.mkdir_p(save_path_with_own_path)
            
            if self.file.is_a? Tempfile
              File.rename(self.file.local_path, save_path_with_filename)
            else
              self.file.rewind if self.file.respond_to?(:rewind)
              File.open(save_path_with_filename, 'w') do |f|
                f << self.file.read
              end
            end
            
            if !new_record? && filename_changed?
              File.delete(File.join(save_path_with_own_path, @previous_filename))
            end
            
          rescue Exception => e
            logger.error("\n\n[ActsAsFile][#{Time.now.rfc2822}] #{e.class}: #{e.message}\n\n")
            errors.add('file', 'could not be saved')
            delete_file
            return false
          ensure
          #  self.file = nil
          end
          
          
          #Delete the file
          #This method is called <tt>after_destroy</tt>.
          def delete_file#:doc:
            File.delete(save_path_with_filename)
          rescue
          ensure
            return true
          end
      
      
      end

    
    end
  end
end