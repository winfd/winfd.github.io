module Jekyll

  class MembersGenerator < Generator

    safe true

    def generate(site)
      site.data['members'].each do |member, data|
        posts = [member, posts_by_member(site, member)]
        build_subpages(site, 'member', posts)
      end
    end

    def build_subpages(site, type, posts)
      posts[1] = posts[1].sort_by { |p| -p.date.to_f }
      paginate(site, type, posts)
    end

    def paginate(site, type, posts)
      pages = Jekyll::Paginate::Pager.calculate_pages(posts[1], site.config['paginate'].to_i)
      (1..pages).each do |num_page|
        pager = Jekyll::Paginate::Pager.new(site, num_page, posts[1], pages)
        path = "/member/#{posts[0]}"
        if num_page > 1
          path = path + "/page#{num_page}"
        end
        newpage = GroupSubPageMember.new(site, site.source, path, type, posts[0])
        newpage.pager = pager
        site.pages << newpage

      end
    end

    private

    def posts_by_member(site, member)
      site.posts.docs.select { |post| post.data['member'] == member }
    end
  end

  class GroupSubPageMember < Page
    def initialize(site, base, dir, type, val)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), "member.html")
      self.data["grouptype"] = type
      self.data[type] = val
    end
  end
end
