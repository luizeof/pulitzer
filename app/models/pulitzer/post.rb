module Pulitzer
  class Post < ActiveRecord::Base
    extend ::FriendlyId
    belongs_to :post_type
    has_many :content_elements, dependent: :destroy
    has_many :post_tags, dependent: :destroy
    delegate :post_type_content_element_types, to: :post_type
    friendly_id :title, use: [:slugged, :finders]

    TAG_MODELS = ["Pulitzer::Tag"] + Pulitzer.tagging_models

    def content_element(label)
      self.content_elements.find_by(label: label)
    end

    def should_generate_new_friendly_id?
      new_record? || title_changed?
    end

  end
end