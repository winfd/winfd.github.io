require 'gemoji'

module Jekyll

  module EmojiFilter

    def emojify(content)
      return false if !content

      config = @context.registers[:site].config
      if config['emoji_dir']
        emoji_dir = config['emoji_dir']
      end

      content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
        if Emoji.find_by_alias($1) and emoji_dir
          '<img alt="' + $1 + '" src="' + emoji_dir + "/#{$1}.png" + '" class="emoji" />'
        else
          match
        end
      end
    end

  end

  class EmojiGenerator < Generator
    def generate(site)
      config = site.config
      return false if not config['emoji_dir']
      return false if config['emoji_dir'].start_with?('http')
      emoji_dir = File.join(config['source'], config['emoji_dir'])
      return false if File.exist?(File.join(emoji_dir, 'smiley.png'))

      puts "           Copying: Emoji from Gemoji to " + config['emoji_dir']

      # Make Emoji directory
      FileUtils.mkdir_p(emoji_dir)

      # Copy Gemoji files
      unicode_emoji_dir = File.join(Emoji.images_path, 'emoji')
      Emoji.all.each do |em|
        # Use the name rather than the unicode character
        FileUtils.cp File.join(unicode_emoji_dir, em.image_filename), File.join(emoji_dir, em.name + '.png')
      end
    end
  end

end

Liquid::Template.register_filter(Jekyll::EmojiFilter)