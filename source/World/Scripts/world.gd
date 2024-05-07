extends Node3D

@onready var menu = $Menu
@onready var ip = $Menu/Control/IPEntry

const tilLand = preload("res://Farming/tilled_land.tscn")
const Player = preload("res://Player/player.tscn")
var port = 6009
var enet_peer = ENetMultiplayerPeer.new()

func disconnect_from_server():
	if Global.players.size() > 1:
		remove_player.rpc()
	else:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
		menu.showme()
		for i in get_children():
			if i.name.begins_with("mpSpawned_"):
				i.queue_free()
		for i in get_node("TilledLand").get_children():
			i.queue_free()
		Global.players = []
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Menu/Camera3D.current = true
		$Terrain.hide()
		$WaterPlane.hide()
		$DayNightCycle.hide()
		$"Menu/Control/Your Ip".placeholder_text = "Local IP: " + str(l_IP_scan())

func ready():
	$Menu/Camera3D.current = true
	$Terrain.hide()
	$WaterPlane.hide()
	$DayNightCycle.hide()
	$"Menu/Control/Your Ip".placeholder_text = "Local IP: " + str(l_IP_scan())
	

func on_host_disconnect():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	menu.show()
	for i in get_children():
		if i.name.begins_with("mpSpawned_"):
			i.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_host_pressed():
	menu.hideme()
	$Terrain.show()
	$WaterPlane.show()
	$DayNightCycle.show()
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(on_host_disconnect)
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
	menu.hideme()
	$Terrain.show()
	$WaterPlane.show()
	$DayNightCycle.show()
	$Menu/Camera3D.current = false
	enet_peer = ENetMultiplayerPeer.new()
	enet_peer.create_client(ip.text, port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.server_disconnected.connect(on_host_disconnect)

@rpc("any_peer", "call_remote", "unreliable")
func remove_player():
	var player = get_node_or_null("mpSpawned_" + str(multiplayer.get_remote_sender_id()))
	print(player)
	if player:
		Global.players.erase(player)
		player.queue_free()
	if multiplayer.is_server():
		remove_player_callback.rpc_id(multiplayer.get_remote_sender_id())

@rpc("any_peer","call_remote","unreliable")
func remove_player_callback():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	menu.showme()
	for i in get_children():
		if i.name.begins_with("mpSpawned_"):
			i.queue_free()
	for i in get_node("TilledLand").get_children():
		i.queue_free()
	Global.players = []
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Menu/Camera3D.current = true
	$Terrain.hide()
	$WaterPlane.hide()
	$DayNightCycle.hide()
	$"Menu/Control/Your Ip".placeholder_text = "Local IP: " + str(l_IP_scan())
 
func add_player(id):
	var player = Player.instantiate()
	player.name = "mpSpawned_" + str(id)
	if is_multiplayer_authority():
		player.get_node("Camera3D").current = true
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
	
