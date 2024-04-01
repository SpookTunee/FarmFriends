extends Node3D

@onready var menu = $CanvasLayer/Menu
@onready var ip = $CanvasLayer/Menu/MarginContainer/VBoxContainer/IPEntry

const tilLand = preload("res://Farming/tilled_land.tscn")
const Player = preload("res://Player/player.tscn")
var port = 6009
var enet_peer = ENetMultiplayerPeer.new()
var newday: bool = true

func disconnect_from_server():
	remove_player.rpc()
	get_tree().quit()

func _unhandled_input(event):
	if Input.is_action_just_pressed("menu"):
		if multiplayer.multiplayer_peer:
			disconnect_from_server()
		#get_tree().quit()
# Called when the node enters the scene tree for the first time.
func _ready():
	$"CanvasLayer/Menu/MarginContainer/VBoxContainer/Your Ip".placeholder_text = "Local IP: " + str(l_IP_scan())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if newday && ((Global.dayfloat-float(Global.day)) >= 0.0):
		handle_plant_growing(true)
		newday = false
	if !newday && ((Global.dayfloat-float(Global.day)) >= 0.333):
		handle_plant_growing(false)
		newday = true

func handle_plant_growing(gon):
	if gon:
		for tland in $TilledLand.get_children():
			if tland.get_node_or_null("PLANT"):
				tland.get_node("PLANT").start_grow()
	else:
		for tland in $TilledLand.get_children():
			if tland.get_node_or_null("PLANT"):
				tland.get_node("PLANT").stop_grow()

func on_host_disconnect():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	menu.show()
	for i in get_children():
		if i.name.begins_with("mpSpawned_"):
			i.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_host_pressed():
	menu.hide()
	
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())
	
	#upnp_settup()

func l_IP_scan():
	var ip_adress
	if OS.has_feature("windows"):
		ip_adress =  IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")),1)
	elif OS.has_feature("x11z"):
		ip_adress =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.get_name() == "macOS":
		for i in IP.get_local_addresses():
			if (!(i.begins_with("127.0"))) && (!(i.begins_with("f"))) && (!(i.begins_with("0:"))):
				return i
		print("WiFi Disconnected.")
		#ip_adress =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	return ip_adress

func _on_join_pressed():
	menu.hide()
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client(ip.text, port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.server_disconnected.connect(on_host_disconnect)

@rpc("any_peer", "call_remote", "unreliable")
func remove_player():
	var player = get_node_or_null("mpSpawned_" + str(multiplayer.get_remote_sender_id()))
	if player:
		Global.players.erase(player)
		player.queue_free()
	remove_player_callback.rpc_id(multiplayer.get_remote_sender_id())

@rpc("any_peer","call_remote","unreliable")
func remove_player_callback():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	menu.show()
	for i in get_children():
		if i.name.begins_with("mpSpawned_"):
			i.queue_free()
	Global.players = []
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
 
func add_player(id):
	var player = Player.instantiate()
	player.name = "mpSpawned_" + str(id)
	add_child(player)
	Global.players.append(player)

func upnp_settup():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()
	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		print("UPNP Discover Failed! Error %s" % discover_result)
	if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
		print("UPNP Invalid Gateway!")
	
	var map_result = upnp.add_port_mapping(port)
	if map_result == UPNP.UPNP_RESULT_SUCCESS:
		print("UPNP Port Mapping Failed! Error %s" % map_result)
	
	print("Successful UPNP")
	


func _on_quit_pressed():
	get_tree().quit()
