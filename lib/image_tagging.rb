require "image_tagging/version"

module ImageTagging
  require "product/product"
  require "tag/tag"

  def self.update_all_products
    Tag.process_all_tags
  end

  def self.update_recent_products
    Tag.process_recent_tags
  end

end

