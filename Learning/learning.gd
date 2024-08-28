extends Node


func _ready():
	complex_test()


func complex_test():
	var test_amount : int = 5000
	for l in 10:
		for el in test_amount:
			var _new_random_number_array = random_number_in_array(l)
			var test = remove_odd_numbers_from_array(_new_random_number_array)
			var _even_number_amount = even_number_amount(test)
			if test.size() != _even_number_amount:
				print('Ошибка в l: {0} и в el {1}'.format([l, el]))
			#if test.size() == _even_number_amount:
				#print('OK')
			#else:
				#print('Error')


func even_number_amount(_input_array: Array):
	var _even_number_amount : int
	for el in _input_array:
		if el % 2 == 0: _even_number_amount += 1
	return _even_number_amount


func remove_odd_numbers_from_array(_input_array: Array):
	var array = _input_array
	var ready_array : Array
	for el in array:
		if el % 2 == 0:
			ready_array.append(el)
	return ready_array


func random_number_in_array(_input_number: int):
	var array : Array
	for el in _input_number: 
		array.append(randi())
	return array


func test_no_odd_numbers_in_array():
	var test_case : Dictionary = {
		'test_array' = [55, 63, 356, 985, 54, 6, 84839548],
		'result' = [356, 54, 6, 84839548]
	}
	for el in test_case:
		var test_result = remove_odd_numbers_from_array(test_case['test_array'])
		if test_case['result'] == test_result:
			return 'OK'
		else:
			return 'Error'





func test_random_number_in_array():
	var test_case: Dictionary = { 'result' = 11 }
	var counter : int = 0
	for el in test_case:
		var test_result = random_number_in_array(test_case['result'])
		counter += 1
		if test_case['result'] == test_result.size():
			print('OK')


#true, if white
func black_or_white_amount(_input_size_board: Vector2i, _input_cell_position: Vector2i, _input_cell_color: bool):
	var size_x = _input_size_board.x
	var size_y = _input_size_board.y
	var cell_color = _input_cell_color
	var _black_cell_amount = black_cell_amount(Vector2i(size_x, size_y), start_cell_color(_input_cell_position, cell_color))
	var _white_cell_amount = black_cell_amount(Vector2i(size_x, size_y), not start_cell_color(_input_cell_position, cell_color))
	
	if _black_cell_amount > _white_cell_amount:
		return 'Black'
	elif _black_cell_amount == _white_cell_amount:
		return 'Equal'
	else:
		return 'White'

var test_cases = {
	"white 2x2": {
		"board_size": Vector2(2, 2),
		"cell_pos": Vector2(2, 2),
		"cell_color": true,
		"output": 'Equal'
	},
	"white 3x3": {
		"board_size": Vector2(3, 3),
		"cell_pos": Vector2(2, 2),
		"cell_color": true,
		"output": "White"
	},
}


func get_test_data(x, y, start):
	var black = get_black_cells(Vector2(x, y), start)
	var white = (x * y) - black
	if black > white:
		return 'Black'
	elif black == white:
		return 'Equal'
	else:
		return 'White'


func get_black_cells(b_size: Vector2, first_cell_color = true):
	var odd = floor(b_size.x / 2)
	var odd_num = floor((b_size.y + 1) / 2)
	var even = floor((b_size.x +1 )/ 2)
	var even_num = floor(b_size.y / 2)
	if first_cell_color:
		return (odd * odd_num) + (even * even_num)
	else:
		return (b_size.x * b_size.y) - ((odd * odd_num) + (even * even_num))


func test_black_or_white_amount(_number_of_iteration: int):
	#for case in test_cases:
		#var test_case = test_cases[case]
		#var test_res = black_or_white_amount(test_case['board_size'], test_case["cell_pos"], test_case['cell_color'])
		#if test_case['output'] == test_res:
			#print('OK')
		#else:
			#print('Тест не пройден тут в значениях {0}'.format([test_case]))
	#return
	
	var test_size = Vector2i.ONE * _number_of_iteration
	var start = false
	
	var random_cell_position = Vector2i(2, 2)
	for y in range(test_size.y):
		for x in range(test_size.x):
			var c_collor = chess_board_cell_color(random_cell_position.x, random_cell_position.y, start)
			var test = black_or_white_amount(Vector2i(x + 1, y + 1), random_cell_position, not c_collor)
			if test != get_test_data(x + 1, y + 1, start):
				print('Тест не пройден тут в значениях {0} {1}'.format([x + 1, y + 1]))
			else:
				print('OK {0} {1}'.format([x + 1, y + 1]))
				
	start = true
	for y in range(test_size.y):
		for x in range(test_size.x):
			var c_collor = chess_board_cell_color(random_cell_position.x, random_cell_position.y, start)
			var test = black_or_white_amount(Vector2i(x + 1, y + 1), random_cell_position, not c_collor)
			if test != get_test_data(x + 1, y + 1, start):
				print('Тест не пройден тут в значениях {0} {1}'.format([x + 1, y + 1]))
			else:
				print('OK {0} {1}'.format([x + 1, y + 1]))

func test_start_cell_color():
	# Доска 1
	var size = Vector2.ONE * 70
	var start = true
	for y in  range(size.y):
		var line = ""
		for x in range(size.x):
			var _test = start_cell_color(Vector2(x+1, y+1), chess_board_cell_color(x, y, start))
			if not _test:
				print("Тест не пройден на значениях {0} {1}".format([x+1, y+1]))
		print(line)
	
	start = false
	for y in  range(size.y):
		var line = ""
		for x in range(size.x):
			var _test = start_cell_color(Vector2(x+1, y+1), chess_board_cell_color(x, y, start))
			if start != _test:
				print("Тест не пройден на значениях {0} {1}".format([x+1, y+1]))
		print(line)

func start_cell_color(_input_size_board: Vector2i, _input_cell_color : bool):
	var size_x = _input_size_board.x
	var size_y = _input_size_board.y
	var input_cell_color = _input_cell_color
	
	if (size_x % 2) == (size_y % 2): return input_cell_color
	else: return not input_cell_color

func black_cell_amount(_input_size_board: Vector2i, _input_start_cell_color: bool):
	var size_x = _input_size_board.x
	var size_y = _input_size_board.y
	var black_cell_counter : int = 0
	var start_cell_color = _input_start_cell_color
	
	if size_x % 2 == 0:
		black_cell_counter = (size_x * size_y) / 2
	else:
		if start_cell_color == false:
			if size_y % 2 == 1: 
				black_cell_counter = (size_x * size_y) / 2 + 1 
			else: 
				black_cell_counter = (size_x * size_y) / 2
		elif start_cell_color == true:
			black_cell_counter = (size_x * size_y) / 2
	
	return black_cell_counter


func chess_board_cell_color(x, y, start: bool):
	var first_cell_color_is_black = start
	var sum = 0
	sum = x % 2 + y % 2
	
	if sum == 1:
		return not first_cell_color_is_black
	return first_cell_color_is_black


func ladder(_input_number_circle: int):
	var number_circle = _input_number_circle
	var current_circle: int
	var steps_counter: int
	
	while current_circle < number_circle:
		steps_counter += 1
		current_circle += steps_counter
	if current_circle > number_circle: print(steps_counter - 1)
	else: print(steps_counter)


func fibonacci_numbers(_input_number: int):
	var number := _input_number
	var first_term : int = 1
	var second_term : int = 1
	var amount : int
	var line : String = str(first_term, ', ', second_term, ', ')
	
# 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233
	while amount < number:
		amount = first_term + second_term
		if amount < number: line += str(amount, ', ')
		elif amount >= number: line += str(amount)
		
		first_term = second_term
		second_term = amount
	print(line)


func get_cell_in_square(x_position, y_position, start_color := true):
	var start_cell = start_color # white
	var cell_color : bool
	var x = x_position
	var y = y_position
	
	#if x % 2 != 0 and y % 2 != 0: cell_color = start_cell
	#if x % 2 == 0 and y % 2 == 0: cell_color = start_cell
	#if x % 2 != 0 and y % 2 == 0: cell_color = not start_cell
	#if x % 2 == 0 and y % 2 != 0: cell_color = not start_cell
	# либо:
	if (x % 2) == (y % 2): cell_color = start_cell
	else: cell_color = not start_cell
	# либо:
	#if (x % 2) + (y % 2) == 1: cell_color = not start_cell
	#else: cell_color = start_cell
	
	print(cell_color)


func get_cell_in_row(x_position, start_color := false):
	var start_cell := start_color #т.е., клетка белая
	var cell_color : bool
	
	if x_position % 2 == 0:
		cell_color = not start_cell
	else:
		cell_color = start_cell
	return cell_color


# true, if black
func get_cell_color(x_pos, y_pos) -> bool:
	var coordinates := Vector2(x_pos,  y_pos)
	for y in range(y_pos):
		var line : String
		for x in range(x_pos):
			y_pos = y
			x_pos = x
			if y % 2 != 0: 
				if x % 2 == 0: line += '# ' 
				else: line += '_ '
			else:
				if x % 2 == 0: line += '_ '
				else: line += '# '
			#if y == 6 and x == 4: print('!!!', line + str(coordinates))
			#else: continue
		#print(line)
	return false


func array_mirroring():
	var array : Array = [1, 2, 3]
	var _size = array.size()
	for idx in array.size():
		print(array[_size - 1 - idx])
		
		#print(array[_size - 2])
		#print(array[_size - 3])


func chesboard():
	var width := 5
	var height := 3
	for y in range(height):
		var line = ''
		for x in range(width):
			if y != 1:
				if x % 2 == 0:
					line += '#'
				else:
					line += '_'
			else:
				if x % 2 == 0:
					line += '_'
				else:
					line += '#'
		print(line)


func snake(input_width: int, input_height: int):
	var height := input_height
	var width := input_width
	var global_number := 0
	for y in range(1, height + 1):
		var x_counter : int = 0
		var line : String = ''
		var string_number := 0
		if y % 2 != 0:
			for x in range(width):
				string_number = global_number - 1
				string_number += 1
				global_number += 1
				line += str(string_number) + ' '
			print(line)
		
		if y % 2 == 0:
			x_counter += global_number + width
			while x_counter != global_number:
				x_counter -= 1
				line += str(x_counter) + ' '
			global_number += width
			print(line)
		#or:
			#for x in range(width): # второе решение
				#y_counter = global_number + width
				#while y_counter != global_number:
					#y_counter -= 1
					#line += str(y_counter) + ' '
				#string_number = global_number + 1
				#string_number -= 1
				#global_number += 1
				#line += ' ' + str(string_number).reverse()
			#print(line.reverse())
			


func individual_element_in_array():
	var array := range(1, 5 + 1)
	var array_b = []
	var start_idx := 1
	var end_idx := 3
	for idx in range(start_idx, end_idx + 1):
		# 2, 3, 4
		array_b.append(array[idx])
		print(array_b)


func remainder_one():
	var line : String
	for el in range(1, 10 + 1):
		if el % 3 == 0:
			line += '*'
		else: 
			line += str(el)
	print(line)


func remainder_two():
	var amount : int
	for el in range(1, 100 + 1):
		var el_amount = el % 5
		amount += el_amount
	print(amount)
