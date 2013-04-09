require 'sprockets/image_compressor/base'

module Sprockets
  module ImageCompressor
    class PngCompressor < Base
      def initialize
        @name = 'pngcrush'
      end

      def compress(content)
        compressed_png_data = ''
        file = Tempfile.new(['in_file', '.png'])
        file.binmode
        file.write content
        file.close
        out = `#{binary_path} -ow #{file.path} 2>&1`

        File.open file.path, "rb" do |compressed_file|
          compressed_png_data = compressed_file.read
        end

        file.unlink

        compressed_png_data
      end
    end
  end
end
