extends Node2D

var damage = 2

func get_damage():
	return damage

func upgrade(stats):
	damage += stats
