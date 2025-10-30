extends Node

var money: int = 0
var tech_levels := {
	"level1": false,
	"level2": false,
	"level3": false,
	"level4": false,
	"level5": false
}

signal money_changed(new_value)

func add_money(amount: int):
	money += amount
	print("Agregando ", amount)
	emit_signal("money_changed", money)

func remove_money(amount: int) -> bool:
	if money >= amount:
		money -= amount
		emit_signal("money_changed", money)
		return true
	return false
