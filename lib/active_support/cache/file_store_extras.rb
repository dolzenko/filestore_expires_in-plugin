
module ActiveSupport
  module Cache
    class FileStore < Store
      alias :original_read :read
      alias :original_exist? :exist?

      def read(name, options = {})
        lastmod = File.mtime(real_file_path(name)) rescue nil
        if lastmod && options.is_a?(Hash) && options[:expires_in] && ((lastmod + options[:expires_in]) <= Time.now)
          nil
        else  
          original_read(name, options)
        end
      end

      def exist?(name, options = nil)
        lastmod = File.mtime(real_file_path(name)) rescue nil
        if lastmod && options.is_a?(Hash) && options[:expires_in] && ((lastmod + options[:expires_in]) <= Time.now)
          false
        else
          original_exist?(name, options)
        end
      end
    end
  end    
end