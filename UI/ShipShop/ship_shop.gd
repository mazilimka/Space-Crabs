extends Panel

var selected_ship_name = "ship_1"
var array_ship_id
var flag_for_lock_button := false


func _ready() -> void:
	Global.PURCHASED_SHIP.append(Global.SHIP_ID['id_1']['name'])
	
	%ShipList.item_selected.connect(ship_list_selected)
	%Buy.pressed.connect(use_buy_button)
	%Exit.pressed.connect(exit_pressed)


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
		Global.PURCHASED_SHIP.append(Global.SHIP_ID[array_ship_id]['name'])
		Global.set_coin(Global.score - Global.SHIPS[selected_ship_name]['price'])
	else: 
		Global.Player.upgrage_ship(Global.SHIPS[selected_ship_name], Global.SHIP_ID[array_ship_id])
	close()


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
	var ship = Global.SHIPS[_ship_name]
	var ships_names = Global.SHIPS.keys()
	
	if Global.score < ship['price'] or flag_for_lock_button == true:
		%Buy.disabled = true
	elif Global.score >= ship['price'] and flag_for_lock_button == false:
		%Buy.disabled = false
	
	var purchased_names = Global.PURCHASED_SHIP
	if purchased_names.has(_ship_name):
		%Buy.text = 'Equip'
	else:
		%Buy.text = 'Buy ' + str(ship['price'])
	%ShipPreview.texture = load(ship['texture'])
	%Info.text = "Rate of Fire: %.2f
	
	Mass: %.2f" % [ship['mass'], ship['rate_of_fire']]
