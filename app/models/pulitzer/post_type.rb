class Pulitzer::PostType < ActiveRecord::Base
  enum kind: [ :template, :partial ]
  has_many :posts, dependent: :destroy
  has_many :partials, dependent: :destroy
  has_many :post_type_content_element_types, dependent: :destroy
  has_many :content_element_types, through: :post_type_content_element_types
  has_many :free_form_section_types, dependent: :destroy
  has_many :layouts, dependent: :destroy

  scope :templates, -> { where(kind: Pulitzer::PostType.kinds[:template])}
  scope :partials, -> { where(kind: Pulitzer::PostType.kinds[:partial])}
  validates :name, :kind, presence: true
  validates :plural, :inclusion => { :in => [true, false] }

  def self.named(label)
    self.find_by(name: label)
  end

  def singular?
    !plural
  end

  def singleton_post
    posts.first
  end

  def singleton_post?
    !plural
  end

  def has_templated_content_elements?
    content_element_types.any?
  end

  def has_free_form_sections?
    free_form_section_types.any?
  end

  def all_element_types
    (post_type_content_element_types.to_a + free_form_section_types.to_a)
  end

  def highest_element_sort
    last_element = all_element_types.max_by(&:sort_order)
    last_element&.sort_order || 0
  end
end
