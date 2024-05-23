require 'gemoji'

module Jekyll

  module EmojiFilter

    def emojify(content)
      return false if !content

      config = @context.registers[:site].config
      if config['emoji_path']
        emoji_path = config['emoji_path']
      end

      content.to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
        if Emoji.find_by_alias($1) and emoji_path
          '<img alt="' + $1 + '" src="' + emoji_path + "/#{$1}.gif" + '" class="emoji" />'
        else
          match
        end
      end
    end

  end

  class EmojiGenerator < Generator
    def generate(site)
      config = site.config
      return false if not config['emoji_path']
      return false if config['emoji_path'].start_with?('http')
      emoji_path = File.join(config['source'], config['emoji_path'])
      return false if File.exist?(File.join(emoji_path, 'default.gif'))

      puts "           Copying: Emoji from Gemoji to " + config['emoji_path']

      # Make Emoji directory
      FileUtils.mkdir_p(emoji_path)

      # Copy Gemoji files
      unicode_emoji_path = File.join(Emoji.images_path, 'emoji')
      Emoji.all.each do |em|
        # Use the name rather than the unicode character
        FileUtils.cp File.join(unicode_emoji_path, em.image_filename), File.join(emoji_path, em.name + '.gif')
      end
    end
  end

end

Liquid::Template.register_filter(Jekyll::EmojiFilter)