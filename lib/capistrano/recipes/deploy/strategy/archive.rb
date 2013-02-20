require 'capistrano/recipes/deploy/strategy/base'

module Capistrano
  module Deploy
    module Strategy

      # This class implements a strategy for deployments with prebuilt
      # packages. It copies the package to each target host and uncompresses
      # it to the release directory. While normally discouraged, you
      # usually want to use the :none SCM with this strategy (or for even less
      # overhead, the :passthrough SCM from capistrano-deploy-scm-passthrough).
      # You'll also need to set :repository to the target archive.
      #
      #   set :scm, :none
      #   set :deploy_via, :archive
      #   set :repository, "target/#{application}.tar.gz"
      #
      # This strategy is meant to be a drop-in replacement for the :copy
      # strategy, and supports all the same configuration variables EXCEPT
      # those that deal with creating the package. For example,
      # :build_script and :copy_exclude are not supported.
      #
      # This deployment strategy also supports a special variable,
      # :copy_compression, which must be one of :gzip, :bz2, or
      # :zip, and which specifies how the package should be decompressed on
      # each host.
      class Archive < Base
        # Copies the package to all target servers, and uncompresses it on
        # each of them into the deployment directory.
        def deploy!
          distribute!
        end

        # Check dependencies.
        def check!
          super.check do |d|
            d.remote.command(decompress(nil).first)
          end
        end

        private

          # Returns the name of the file that the source code will be
          # compressed to.
          def filename
            @filename ||= File.expand_path(configuration[:repository], Dir.pwd)
          end

          # The directory on the remote server to which the archive should be
          # copied
          def remote_dir
            @remote_dir ||= configuration[:copy_remote_dir] || "/tmp"
          end

          # The location on the remote server where the file should be
          # temporarily stored.
          def remote_filename
            @remote_filename ||= File.join(remote_dir, "#{File.basename(configuration[:release_name])}.#{compression.extension}")
          end

          # A struct for representing the specifics of a compression type.
          # Commands are arrays, where the first element is the utility to be
          # used to perform the compression or decompression.
          Compression = Struct.new(:extension, :decompress_command)

          # The compression method to use, defaults to :gzip.
          def compression
            remote_tar = configuration[:copy_remote_tar] || 'tar'
            remote_unzip = configuration[:copy_remote_unzip] || 'unzip'

            type = configuration[:copy_compression] || :gzip
            case type
            when :gzip, :gz   then Compression.new("tar.gz",  [remote_tar, 'xzf'])
            when :bzip2, :bz2 then Compression.new("tar.bz2", [remote_tar, 'xjf'])
            when :zip         then Compression.new("zip",     [remote_unzip, '-q'])
            else raise ArgumentError, "invalid compression type #{type.inspect}"
            end
          end

          # Returns the command necessary to decompress the given file,
          # relative to the current working directory. It must also
          # preserve the directory structure in the file.
          def decompress(file)
            compression.decompress_command + [file]
          end

          # Decompress the package on the remote host.
          def decompress_remote_file
            run "mkdir #{configuration[:release_path]} && cd #{configuration[:release_path]} && #{decompress(remote_filename).join(" ")} && rm #{remote_filename}"
          end

          # Distributes the file to the remote hosts.
          def distribute!
            upload(filename, remote_filename)
            decompress_remote_file
          end
      end

    end
  end
end
