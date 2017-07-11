require "image_tagging/version"

module ImageTagging
  require "product/product"
  require "image_tag/image_tag"

  def self.update_all_products
    ImageTag.process_all_tags
  end

  def self.update_recent_products
    ImageTag.process_recent_tags
  end

end

