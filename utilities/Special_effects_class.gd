extends Node

class_name SpecialEffects

func AddItemToInventory(new_item, target=null):
	AppInfo.Get_item(new_item)
	SignalsResource._refresh_item_list.emit()

func stamina_boost(amount, target):
	target.current_stamina = min(target.current_stamina + amount, target.member_info.total_stamina)
	target.display_stamina_value()
