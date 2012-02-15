module Forem
  module BreadcrumbsHelper
    def breadcrumbs_for_category category, display_current_link = false
     crumbs = unless display_current_link
        [category]
      else
        [link_to(category, category)]
      end

      while category = category.category
        crumbs << link_to(category, category)
      end

      crumbs.reverse.join(' &raquo; ').html_safe
    end

    def breadcrumbs_for_forum forum, display_current_link = false
      crumb = "#{breadcrumbs_for_category(forum.category, true)} &raquo; "
      
      crumb << if display_current_link
        link_to(forum.title, forum)
      else
        forum.title
      end

      crumb.html_safe
    end
  end
end