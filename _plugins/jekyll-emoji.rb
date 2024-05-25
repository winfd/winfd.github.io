require 'pathname'

module Jekyll
    module Filters
        def emoji(text)
            sitecontext = @context.registers[:site];
			
            unless theme == false
                imgmap = YAML.load_file("_includes/emoji.yml");

                ext = (imgmap.shift)[1]
                imgmap.each do |emoji, regex|
                    if File.exists?((Pathname.new(sitecontext.source) + "assets/images/emoji/#{emoji}.#{ext}").expand_path)
                        if regex == "" then regex = "n^" end
                        text.gsub!(Regexp.new("(^|\\s|<(?!(?:!nosmiley|pre|code)).*?>)(?:#{regex}|(?:\\{:#{emoji}:\\}))(?=\\W?(?:\\s|<[^!].*?>|$))", "i"), "\\1<img src='#{sitecontext.config['root']}assets/images/emoji/#{emoji}.#{ext}' alt='[#{emoji}]' class='emoji'/>")
                    end
                end
                imgmap.each do |emoji, regex|
                    if regex == "" then regex = "n^" end
                    text.gsub!(Regexp.new("(^|\\s|<(?!(?:!nosmiley|pre|code)).*?>)(=*)=(#{regex}|(?:\\{:#{emoji}:\\}))=(?=\\2\\W?(?:\\s|<[^!].*?>|$))", "i"), "\\1<!nosmiley-->\\2\\3<!-->")
                end
            end
            text
        end
    end
end
