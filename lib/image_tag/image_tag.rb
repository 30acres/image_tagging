module ImageTagging
  class ImageTag
    def initialize(product)
      @product = product
      @initial_product_tags = product.tags
      @tag_name = 'Admin: No Images'
    end

    def product_has_images?
      @product.images.any?
    end

    def removed_initial_tags
      # binding.pry
      @product.tags.split(',').delete_if { |x| x.include?(@tag_name) }
    end

    def add_image_tags
      @product.tags = removed_initial_tags
      if product_has_images?
        @product.tags = [@product.tags,image_tag].join(',')
      end
      puts "PRODUCT ID (before): #{@product.id}"
      puts "#{initial_tags} ====> #{cleaned_tags}"
      if tags_changed?
        # puts "#{@product.title} : Updated Tags!"
        @product.tags = cleaned_tags
        @product.save!
        puts "PRODUCT ID (after): #{@product.id}"
        sleep(1.second) ## For the API
      else
        # puts "#{@product.title} : No Change in Tags!"
      end
    end

    # def has_variants?
    #   variants.any?
    # end
    #
    # def variants
    #   @product.variants
    # end
    #
    def cleaned_tags
      @product.tags.split(',').reject{ |c| c.empty? or c == "  " }.uniq.join(',')
    end

    def initial_tags
      @initial_product_tags
    end

    def tags_changed?
      clean_tags(initial_tags) != clean_tags(cleaned_tags)
    end

    def clean_tags(tags)
      tags.split(',').map{ |t| t.strip }.uniq.sort
    end

    def image_tag
      tag = ''
      unless product_has_images?
        tag = @tag_name
      end
      tag
    end

    def self.process_all_tags
      ImageTagging::ImageProduct.all_products_array.each do |page|
        page.each do |product|
          ImageTag.new(product).add_image_tags
        end
      end
    end

    def self.process_recent_tags
      ImageTagging::ImageProduct.recent_products_array.each do |page|
        page.each do |product|
          ImageTag.new(product).add_image_tags
        end
      end
    end
    

  end
end
