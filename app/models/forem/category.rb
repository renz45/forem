module Forem
  class Category < ActiveRecord::Base
    has_many :forums
    # NOTE: Proof of concept for nested categories
    has_many :sub_categories, class_name: "Forem::Category", foreign_key: "category_id"
    belongs_to :parent_category, class_name: "Forem::Category", foreign_key: "category_id"
    validates :name, :presence => true

    def to_s
      name
    end

  end
end
