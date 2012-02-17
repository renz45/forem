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

      crumb = []
      add_category_forms = content_tag(:p,"Select or create a new parent category for #{category.name}".html_safe)
      add_category_forms << content_tag(:div,"Select: #{select_next_category_form(category)} or create #{add_next_category_form(category)}".html_safe)
    
      if args[:skip_first_name]
        crumb << [category.name]
        crumb << remove_category_form(category)
      else
        crumb << [category.name]
        crumb << remove_category_form(category)
        category = category.category
      end

      while category = category.category # category
        crumb << content_tag(:span,category.name, 'data-id' => category.id)
      end

      crumb << "Forums"

      html = "#{crumb.reverse.join(' &raquo; ')}#{add_category_forms}"

      content_tag :div, html.html_safe, class: 'edit-breadcrumbs-for-category'
    end

    def edit_breadcrumbs_for_forum forum
      "#{edit_breadcrumbs_for_category forum.category, skip_first_name: true} &raquo; #{category_breadcrumb_form forum}".html_safe
    end

    private

    def remove_category_form category
      return unless category.category

      form_for [:admin, category], html: {class: 'forem-remove-category'} do |f|
        form_elements = if category.category.category
          f.hidden_field :category_id, value: category.category.category.id
        else
          f.hidden_field :category_id, value: ''
        end
        form_elements << f.submit(category.category.name, name: category.name)
        form_elements
      end
    end

    def select_next_category_form category 
      form_for [:admin, category], html: {class: 'forem-breadcrumb-form', style: 'display:inline;'} do |f|
        if category.category
          f.select :category_id, options_from_collection_for_select(category.category.categories.where("id != #{category.id}"), 'id', 'name'),include_blank: true
        else
          f.select :category_id, options_from_collection_for_select(Forem::Category.where("category_id =  nil, id != #{category.id}"), 'id', 'name')
        end  
      end
    end

    def add_next_category_form category
      form_for [:admin, Category.new], html: {class: 'forem-breadcrumb-form', style: 'display:inline;'} do |f|
        form_elements = hidden_field_tag('child_category', category.id)
        form_elements << f.text_field(:name)
        form_elements << f.submit('Add')

        form_elements
      end
    end



    def category_breadcrumb_form category
      
      form_for [:admin, category], html: {class: 'forem-breadcrumb-form', style: 'display:inline;'} do |f|
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