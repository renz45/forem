module Forem
  module BreadcrumbsHelper
    def breadcrumbs_for_category category, args = {}
      args[:display_current_link] ||= false
      args[:admin] ||= false
    
      crumbs = unless args[:display_current_link]
        [category]
      else
        if args[:admin]
          [link_to(category, admin_category_url(category))]
        else
          [link_to(category, category)]
        end
      end

      while category = category.category
        crumbs << if args[:admin]
          link_to(category, admin_category_url(category))
        else
          link_to(category, category)
        end
      end
      crumbs << if args[:admin]
        link_to('Forums', root_url)
      else
        link_to('Forums', admin_root_url)
      end

      crumbs.reverse.join(' &raquo; ').html_safe
    end

    def breadcrumbs_for_forum forum, args = {}
      args[:display_current_link] ||= false
      args[:admin] ||= false

      crumb = "#{breadcrumbs_for_category(forum.category, display_current_link: true)} &raquo; "
      
      crumb << if args[:display_current_link]
        if args[:admin]
          link_to(forum.title, admin_forum_url(forum))
        else
          link_to(forum.title, forum)
        end
      else
        forum.title
      end

      crumb.html_safe
    end

    def edit_breadcrumbs_for_category category, args = {}
      args[:skip_first_name] ||= false
      
      if args[:skip_first_name]
        crumb = []
      else
        crumb = [category.name]
      end

      while category
        category_form = category_breadcrumb_form(category)
        crumb << category_form if category_form
        category = category.category
      end

      crumb << "Forums"

      crumb.reverse.join(' &raquo; ').html_safe
    end

    def edit_breadcrumbs_for_forum forum
      "#{edit_breadcrumbs_for_category forum.category, skip_first_name: true} &raquo; #{category_breadcrumb_form forum}".html_safe
    end

    private
    def category_breadcrumb_form category
      
      form_for [:admin, category], html: {class: 'forem-breadcrumb-form', style: 'display:inline'} do |f|
        return unless category.category
        if parent_category = category.category.category
          f.select :category_id, options_from_collection_for_select(parent_category.categories, 'id', 'name', selected: category.category.id)
        else
          f.select :category_id, options_from_collection_for_select(Forem::Category.where(category_id: nil), 'id', 'name', selected: category.category.id)
        end
      end
    end
  end
end