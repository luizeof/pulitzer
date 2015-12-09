module Pulitzer
  class ContentElement < ActiveRecord::Base
    mount_uploader :image, Pulitzer::ImageUploader
    enum kind: [ :template, :free_form ]

    # Associations
    belongs_to :version
    belongs_to :content_element_type
    belongs_to :post_type_content_element_type
    delegate :type, :text_type?, :image_type?, :video_type?, to: :content_element_type
    delegate :post, to: :version

    # Validations
    validates :label, presence: true, uniqueness: { scope: :version_id }

    # Callbacks
    before_save :handle_sort_order

    # Scopes
    default_scope { order(id: :asc) }
    scope :free_form, -> { where(kind: kinds[:free_form]).reorder(sort_order: :asc) }

    def video_link
      if video_type? && !body.nil?
        vimeo_video(body) || youtube_video(body)
      end
    end

    def html
      body.blank? ? "" : body.html_safe
    end

    def empty_body?
      image_type? ? !image? : body.blank?
    end

private
    def vimeo_video(element)
      if element.match(/vimeo/) && code = element.split("/").last
        "https://player.vimeo.com/video/#{code}"
      end
    end

    def youtube_video(element)
      if element.match(/youtube/) && code = element.split("=").last
        "https://www.youtube.com/embed/#{code}"
      end
    end

    def handle_sort_order
      if new_record? && sort_order.nil? && free_form?
        self.sort_order = version.free_form_content_elements.maximum(:sort_order).to_i + 1
      end
    end

  end
end
