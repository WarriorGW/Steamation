extends Node

var money: int = 0
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
