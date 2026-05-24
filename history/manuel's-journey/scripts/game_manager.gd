extends Node

var demon_boss_is_dead = false
var hell_boss_is_dead = false

func open_portal3():
	get_parent().get_node("Portals").get_node("Portal3").open()
	
func open_portal5():
	get_parent().get_node("Portals").get_node("Portal5").open()
	
func open_portal7():
	get_parent().get_node("Portals").get_node("Portal7").open()

func demon_boss_died():
	demon_boss_is_dead = true
	
func hell_boss_died():
	hell_boss_is_dead = true





	
