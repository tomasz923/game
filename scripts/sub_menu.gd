extends Control

@onready var button_pressed: AudioStreamPlayer = $ButtonPressed
@onready var character_sheet_button: Button = $BlackRectangle/SettingsContainer/CharacterSheetButton
@onready var inventory_button: Button = $BlackRectangle/SettingsContainer/InventoryButton
@onready var moves_button: Button = $BlackRectangle/SettingsContainer/MovesButton
@onready var journal_button: Button = $BlackRectangle/SettingsContainer/JournalButton

@onready var portrait: TextureRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/Portrait
@onready var name_label: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/NameLabel
@onready var class_label: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/ClassLabel
@onready var level_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/LevelVal
@onready var xp_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/XPVal
@onready var hp_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/HPVal
@onready var ap_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/FirstLayer/InfoBox/QucikStats/RightColumn/APVal

@onready var str_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/StrPanel
@onready var strength_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/StrPanel/StrengthVal
@onready var dex_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/DexPanel
@onready var dexterity_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/DexPanel/DexterityVal
@onready var end_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/EndPanel
@onready var endurance_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/EndPanel/EnduranceVal
@onready var pro_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ProPanel
@onready var processing_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ProPanel/ProcessingVal
@onready var mem_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/MemPanel
@onready var memory_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/MemPanel/MemoryVal
@onready var cha_panel: ColorRect = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ChaPanel
@onready var charisma_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/SecondLayer/ChaPanel/CharismaVal

@onready var coins_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/ThirdLayer/CurrencyContainer/CoinsVal
@onready var supplies_val: Label = $ContentContainer/PanelsContainer/LeftPanelContainer/Container/ThirdLayer/SuppliesContainer/SuppliesVal
