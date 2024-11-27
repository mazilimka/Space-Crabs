extends Panel

var selected_ship_name = "ship_1"
var array_ship_id
var flag_for_lock_button := false
var curr_toggled_ship := 1


func _ready() -> void:
	%Ship1.pressed.connect(ship1_pressed)
	%Ship2.pressed.connect(ship2_pressed)
	%Ship3.pressed.connect(ship3_pressed)
	%Ship4.pressed.connect(ship4_pressed)
	%Ship5.pressed.connect(ship5_pressed)
	%Ship6.pressed.connect(ship6_pressed)
	Global.PURCHASED_SHIP.append(Global.SHIP_ID['id_1']['name'])
	Global.next_ship_id += 1
	%ShipItem.item_selected.connect(ship_list_selected)
	%Buy.pressed.connect(use_buy_button)
	%Exit.pressed.connect(exit_pressed)


func ship1_pressed():
	curr_toggled_ship = 1
	_identif_selected_ship()

func ship2_pressed():
	curr_toggled_ship = 2
	_identif_selected_ship()

func ship3_pressed():
	curr_toggled_ship = 3
	_identif_selected_ship()

func ship4_pressed():
	curr_toggled_ship = 4
	_identif_selected_ship()

func ship5_pressed():
	curr_toggled_ship = 5
	_identif_selected_ship()

func ship6_pressed():
	curr_toggled_ship = 6
	_identif_selected_ship()


func _identif_selected_ship():
	selected_ship_name = Global.SHIPS.keys()[curr_toggled_ship - 1]
	array_ship_id = Global.SHIP_ID.keys()[curr_toggled_ship - 1]
	
	if Global.Player.current_ship == Global.SHIP_ID[array_ship_id]['name']:
		%Buy.disabled = true
		flag_for_lock_button = true
	else: 
		%Buy.disabled = false
		flag_for_lock_button = false
	update_ship_info(selected_ship_name)


func open():
	get_tree().paused = true
	MainHud.change_stage('ShipShop')
	show()
	update_ship_info(Global.Player.current_ship)
	%Buy.disabled = true


func close():
	get_tree().paused = false
	MainHud.change_stage('GameplayHud')
	hide()


func use_buy_button():
	if %Buy.text != 'Equip':
		Global.Player.upgrage_ship(Global.SHIPS[selected_ship_name], Global.SHIP_ID[array_ship_id])
		Global.next_ship_id += 1
		Global.PURCHASED_SHIP.append(Global.SHIP_ID[array_ship_id]['name'])
		Global.set_coin(Global.score - Global.SHIPS[selected_ship_name]['price'])
		Global.purchased_ships_counter += 1
		
		%Buy.disabled = true
		%Buy.text = 'Equip'
	else: 
		Global.Player.upgrage_ship(Global.SHIPS[selected_ship_name], Global.SHIP_ID[array_ship_id])
	close()
	
	if Global.is_continue_game == true:
		return
	if Global.PURCHASED_SHIP.size() == 6:
		MainHud.change_stage('GameComplete')
		curr_toggled_ship = 1
		get_tree().paused = true


func exit_pressed():
	close()


func ship_list_selected(index: int):
	selected_ship_name = Global.SHIPS.keys()[index]
	array_ship_id = Global.SHIP_ID.keys()[index]
	
	if Global.Player.current_ship == Global.SHIP_ID[array_ship_id]['name']:
		%Buy.disabled = true
		flag_for_lock_button = true
	else: 
		%Buy.disabled = false
		flag_for_lock_button = false
	update_ship_info(selected_ship_name)


func update_ship_info(_ship_name):
	print(Global.SHIPS[_ship_name]['id'])
	var ship = Global.SHIPS[_ship_name]
	var ships_names = Global.SHIPS.keys()
	
	if Global.purchased_ships_counter == Global.SHIPS[_ship_name]['needs_lvl']:
		if Global.score < ship['price'] or flag_for_lock_button == true:
			%Buy.disabled = true
		elif Global.score >= ship['price'] and flag_for_lock_button == false:
			%Buy.disabled = false
	elif Global.purchased_ships_counter < Global.SHIPS[_ship_name]['id']:
		%Buy.disabled = true
		%Buy.text = 'Buy the prev. ship'
	elif Global.purchased_ships_counter < Global.SHIPS[_ship_name]['id']:
		%Buy.disabled = false
		%Buy.text = 'Equip'
	
	var purchased_names = Global.PURCHASED_SHIP
	if purchased_names.has(_ship_name):
		%Buy.text = 'Equip'
	else:
		%Buy.text = 'Buy: ' + str(ship['price'])
	
	%ShipPreview.texture = load(ship['texture'])
	%Info.text = "%s
	
	Needs level: %s
	
	Rate of Fire: %.2f
	
	Mass: %.2f" % [ship['info'], ship['needs_lvl'], ship['mass'], ship['rate_of_fire']]
