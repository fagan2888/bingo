class ComputerPlay
   
  #array = [[15, 19, 24, 11, 20], [23, 2, 5, 13, 12], [10, 14, 4, 7, 9], [17, 21, 6, 25, 22], [18, 3, 1, 16, 8]]
  
  def initialize(array)
	  @line_array = convert_into_sequence_of_line(array)
	  @elements = []
	  array.each {|x| x.each {|y| @elements << y }}
	  @count = array.count
  end

  def convert_into_sequence_of_line(array)
    line_array = []
    
    line_array += array
    
    diag_temp1 = []
    diag_temp2 = []
    array.each_index do |x|
    	temp = []
      array.each_index do |y|
      	temp << array[y][x]
      	if  x == y 
      	  diag_temp1 << array[x][y]
      	end

      	if  (x + y) == (array.count - 1)
      		diag_temp2 << array[x][y]
      	 end
      end
      line_array << temp
    end
    line_array << diag_temp1
    line_array << diag_temp2

    line_array
  end

  def total_cut_lines
    count = 0
    @line_array.each do |line|
      if line.all? {|x| x == 0 || x == "Y"}
      	count += 1
      end
    end
    return count
  end

  def find_best_element
    @elements.delete(0)
    element = find_best_among_array(@elements)
  end

  def find_best_among_array(elements)
  	hash_of_score = {}
    elements.each do |element|
      array = skip_already_zero_line
      array = updated_array(element, array)
      max_element_in_row, score, row_hash = calculate_score(array)
      hash_of_score[element] = row_hash
    end
    #sort_array = hash_of_score.sort_by {|key,value| value[0]}.reverse
    #max_score = sort_array[0][1][0]
    #element_array = {}
    #sort_array.each do |x|
    #	if x[1][0] == max_score
    #		element_array[x[0]] = [x[1][1], x[1][2]]
   # 	end
    #end
    #debugger
    #top_element = element_array.sort_by{|k,v| v[0]}.reverse
    #top_score = top_element[0][1][0]
    #top_array_element = []
    #top_element.each do |element|
     # if top_score == element[1][0]
      #  top_array_element[element[0]] = element[1][1]
      #end
    #end
    #temp_array = []
    row_array = hash_of_score.map {|k,v| v}
    top_row_score = row_array.sort_by {|row_hash| row_hash.collect {|i| i}}.reverse[0]
    temp_array_element = hash_of_score.select{|key, hash| hash == top_row_score }.map{|k,v| k}
    common_element = []
    if temp_array_element.count > 1
    	common_element = check_diagonal_element(temp_array_element)
    end
    if common_element.count >= 1
      element = common_element[0]
    else
    	element = temp_array_element[0]
    end
    element
  end

  def check_next_row(element, matrix)

  end

  def check_diagonal_element(element_array)
  	digonal_element = @line_array[@count-1] + @line_array[@count -2]
  	digonal_element.flatten
  	digonal_element & element_array
  end

  def updated_array(element, array)
  	array.map! {|line| line.map! {|x| x == (element)? -1:x}}
    array
  end

  def skip_already_zero_line
    array = @line_array.collect &:dup
    array.map! do |line|
      if line.all? {|x| x == line[0]}
        line.map! {|x| -3}
      else
        line
      end
    end
    array
  end

  def calculate_score(array)
  	score_hash = {}
    total_score = 0
  	array.each do |line|
      if line.include? -1
        score_hash[array.index(line)] = line.count(0) + 1
      else
        score_hash[array.index(line)] = 0
      end
      total_score += line.count(0) + 1
  	end
    max_element_in_row = score_hash.sort_by {|k,v| v}.reverse[0][1]
    row_hash = score_hash.sort_by{|k,v| v}.reverse.map!{|v| v[1]}
  	return max_element_in_row, total_score, row_hash
  end
end