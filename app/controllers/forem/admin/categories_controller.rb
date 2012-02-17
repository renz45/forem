module Forem
  module Admin
    class CategoriesController < BaseController
      before_filter :find_category, :only => [:edit, :update, :destroy]

      def index
        @categories = Forem::Category.where(category_id: nil)
      end

      def show
        @category = Forem::Category.find(params[:id])
      end

      def new
        @category =  Forem::Category.new
      end

      def create
        @category = Forem::Category.new(params[:category])
        

        if @category.save
          flash[:notice] = t("forem.admin.category.created")

          if params[:child_category]
            child_category = Forem::Category.find(params[:child_category])
            @category.category_id = child_category.category_id
            @category.save
            child_category.category_id = @category.id
            child_category.save
          end

          # redirect_to admin_categories_path
        else
          flash.now.alert = t("forem.admin.category.not_created")
          # render :action => "new"
        end

        redirect_to :back
      end

      def edit
      end

      def update
        if @category.update_attributes(params[:category])
          # flash[:notice] = t("forem.admin.category.updated")
          # redirect_to admin_categories_path
          redirect_to :back
        else
          flash.now.alert = t("forem.admin.category.not_updated")
          render :action => "edit"
        end
      end

      def destroy
        @category.destroy
        flash[:notice] = t("forem.admin.category.deleted")
        redirect_to admin_categories_path
      end

      private
        def find_category
          @category = Forem::Category.find(params[:id])
        end

    end
  end
end
