  def find_possible_combinations(dictionary, target)
    useful_dict = dictionary.select{|i| target.include?(i)}.uniq #reject dictionary items which are not parts of a target
    combinations = [] #initial combinations - empty array
    # select dictionary items which match target from the beginning
    partial_combinations = useful_dict.select{|dict_item| target =~ Regexp.new('^'+dict_item)}
    #split complete and partial matches
    combinations |= partial_combinations.select{|c|c==target}
    partial_combinations.reject!{|c|c==target}
    while partial_combinations.size>0 do #loop while there're some partial matches
      next_step = [] #next matching parts
      partial_combinations.each do |c|
        next_step |= useful_dict.select{|dict_item| target =~ Regexp.new('^'+c.gsub(' ','')+dict_item)}
      end
      new_partial=[] #new partial matches
      partial_combinations.each do |c|
        next_step.each{|nxt| new_partial << c+' '+nxt if target =~ Regexp.new(('^'+c+nxt).gsub(' ',''))}
      end
      partial_combinations = new_partial #update partial matches
      combinations |= partial_combinations.select{|c|c.gsub(' ','')==target} #update combinations
      partial_combinations.reject!{|c|c.gsub(' ','')==target} #reject full matches
    end
    return combinations
  end

  dict = ['a','b','c','ab','abc']
  target = 'aabc'
#  render :text => find_possible_combinations(dict, target).inspect
puts 'Possible combination:'+find_possible_combinations(dict, target).inspect
