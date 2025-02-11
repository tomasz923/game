extends MachineStats
class_name EnemyStats

enum EnemyType {
	DECOY
}

@export_category("Enemy Stats")
@export var enemy_class: EnemyType = EnemyType.DECOY
@export var enemy_name: String
