module ImageTagging
  class ImageTag
    def initialize(product)
      @product = product
      @initial_product_tags = product.tags
    end

    def product_has_image
      binding.pry
    end

    def removed_initial_tags
      # binding.pry
      @product.tags.split(',').delete_if { |x| x.include?('Admin: ') }
    end

    def add_image_tags
      @product.tags = removed_initial_tags
      if has_size_option?      
        if has_variants?
          variants.each do |variant|
            @product.tags = [@product.tags,image_tag(variant)].join(',')
          end
        end
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

    def image_tag(v)
      tag = ''
      if v.inventory_quantity >= 1
        tag = TAG_NAME
      end
      tag
    end

    def self.process_all_tags
      Product.all_products_array.each do |page|
        page.each do |product|
          ImageTag.new(product).add_image_tags
        end
      end
    end

    def self.process_recent_tags
      Product.recent_products_array.each do |page|
        page.each do |product|
          ImageTag.new(product).add_image_tags
        end
      end
    end
    

  end
end
