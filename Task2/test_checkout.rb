require './checkout_system'
#define rules
rule1={:product=>'FR',:rule_type=>:buy_x_get_one_free,:rule_params=>{:num_items=>1}}
rule2={:product=>'SR',:rule_type=>:discount_if_more_than,:rule_params=>{:num_items=>2,:new_price=>4.5}}
co = Checkout.new(rule1, rule2)
items = ['FR', 'SR', 'FR', 'FR', 'CF']
#items = ['FR', 'FR']
#items = ['SR', 'SR', 'FR', 'SR']
items.each{|i| co.scan(i)}
total_cost = co.total
puts 'Items: '+items.inspect
puts 'Total: '+total_cost.to_s
