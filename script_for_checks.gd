extends Node

func _ready():
	test_black_or_white_amount(50)
	#print(start_cell_color(Vector2i(4, 2), false))
	#print(black_cell_amount(Vector2i(3, 5), false))

#true, if white
func black_or_white_amount(_input_size_board: Vector2i, _input_cell_position: Vector2i, _input_cell_color: bool):
	var size_x = _input_size_board.x
	var size_y = _input_size_board.y
	var cell_color = _input_cell_color
	var _black_cell_amount = black_cell_amount(Vector2i(size_x, size_y), start_cell_color(Vector2i(size_x, size_y), cell_color))
	var _white_cell_amount = black_cell_amount(Vector2i(size_x, size_y), start_cell_color(Vector2i(size_x, size_y), not cell_color))
	
	if _black_cell_amount > _white_cell_amount:
		return 'Black'
	elif _black_cell_amount == _white_cell_amount:
		return 'Equal'
	else:
		return 'White'


func test_black_or_white_amount(_number_of_iteration: int):
	var test_size = Vector2i.ONE * _number_of_iteration
	var random_cell_position = Vector2i(randi(), randi())
	for y in range(test_size.y):
		var start = false
		for x in range(test_size.x):
			var test = black_or_white_amount(Vector2i(x + 1, y + 1), random_cell_position, start)
			if not test:
				print('Тест не пройден тут в значениях {0} {1}'.format([x + 1, y + 1]))
	
	for y in range(test_size.y):
		var start = true
		for x in range(test_size.x):
			var test = black_or_white_amount(Vector2i(x + 1, y + 1), random_cell_position, start)
			if not test:
				print('Тест не пройден тут в значениях {0} {1}'.format([x + 1, y + 1]))







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
