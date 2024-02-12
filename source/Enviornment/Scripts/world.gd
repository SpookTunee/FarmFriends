extends Node3D

@onready var menu = $CanvasLayer/Menu
@onready var ip = $CanvasLayer/Menu/MarginContainer/VBoxContainer/IPEntry

const Player = preload("res://Player/player.tscn")
var port = 9999
var enet_peer = ENetMultiplayerPeer.new()

func disconnect_from_server():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	remove_player.rpc(multiplayer.get_unique_id())
	multiplayer.multiplayer_peer = null
	menu.show()
	for i in get_children():
		if i.name.begins_with("mpSpawned_"):
			i.queue_free()

func _unhandled_input(event):
	if Input.is_action_just_pressed("menu"):
		disconnect_from_server()
		#get_tree().quit()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	$"CanvasLayer/Menu/MarginContainer/VBoxContainer/Your Ip".placeholder_text = "Local IP: " + str(l_IP_scan())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_host_disconnect():
	disconnect_from_server()

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
	elif OS.has_feature("x11"):
		ip_adress =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	elif OS.get_name() == "macOS":
		for i in IP.get_local_addresses():
			if (!(i.begins_with("127.0"))) && (!(i.begins_with("fe"))) && (!(i.begins_with("0:"))):
				return i
		print("error")
		#ip_adress =  IP.resolve_hostname(str(OS.get_environment("HOSTNAME")),1)
	return ip_adress

func _on_join_pressed():
	menu.hide()
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client(ip.text, port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.server_disconnected.connect(on_host_disconnect)

@rpc("any_peer", "call_remote", "unreliable")
func remove_player(id):
	var player = get_node_or_null("mpSpawned_" + str(id))
	if player:
		player.queue_free()

func add_player(id):
	var player = Player.instantiate()
	player.name = "mpSpawned_" + str(id)
	add_child(player)


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
