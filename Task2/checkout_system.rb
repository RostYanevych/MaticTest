class Checkout
  attr_reader :total, :rules, :products, :purchased_items
  def initialize(*rules)
    @total=0
    @rules=rules #rules from params
    @purchased_items = []
    #define known products
    @products=[{:type=>'FR',:name=>'Fruit Tea',:price=>3.11},
               {:type=>'SR',:name=>'Strawberries',:price=>5},
               {:type=>'CF',:name=>'Coffee',:price=>11.23}]
  end

  def scan(product) #scan method. adds product to purchased_items and recalculates price
    prod = @products.detect{|p|p[:type]==product} #find product
    raise 'Unknown product' unless prod
    @purchased_items << product #add product to cart
    recalc_price #recalc cart price
  end

  private

  def recalc_price #price recalculation
    @total = 0
    groupped_products = @purchased_items.group_by{|p|p} #group products by type
    groupped_products.each do |prod_type,items| #calculate price of each product group and add to total
      @total+=get_price(prod_type,items.size)
    end
  end

  def get_price(prod_type,count) #calculates price of <count> items of <prod_type> type 
    rule = @rules.detect{|r|r[:product]==prod_type} #find rule
    prod = @products.detect{|p|p[:type]==prod_type} #find product
    return prod[:price] unless rule #return standard price if no rule defined for this type 
    case rule[:rule_type] #calculate price, depending on rule type
      when :buy_x_get_one_free
        number_of_free_items = (count / (rule[:rule_params][:num_items]+1)).ceil
        return (count-number_of_free_items)*prod[:price]
      when :discount_if_more_than
        if count > rule[:rule_params][:num_items]
          return rule[:rule_params][:new_price]*count
        else
          return prod[:price]*count
        end
      else
        raise 'Unknown rule'
    end
  end
end
