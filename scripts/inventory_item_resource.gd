extends Node3D
class_name InventoryItem

@export var item_name: String = 'missing_name' 
@export var item_description: String = 'missing_description'
@export var item_picture: Texture2D
@export var value: int = 0
@export var can_be_sold: bool = true
@export var executable_script: Script 


#@export var damage_bonus: int = 0
#@export var piercing: int = 0
#@export var ammo: int = 0
#@export var value: int = 0
#@export var can_be_sold: bool = true

#@export_category("Item Perks")
#@export var forceful: bool
#@export var ignores_protection: bool
#@export var messy: bool
#@export var precise: bool
#@export var relaod: bool
#@export var stun: bool
