extends Node

signal changed
var day: int = 1
var period: int = 0
var seconds: float = 0.0
var seconds_per_period: float = 75.0
var hp: int = 100
var energy: float = 100.0
var money: int = 300
var potions: int = 2
var wood: int = 0
var stones: int = 0
var experience: int = 0
var affinity: int = 0
var quest_stage: int = 0
var cats_found: int = 0
var bridge_repaired: bool = false
var flags: Dictionary = {}
var dialogue_open: bool = false
var inventory_open: bool = false
var current_map: String = "cidade"
var selected_slot: int = 0
const SLOTS: Array[String] = ["espada", "cajado", "pocao", "", "", "", "", "", "",]
const PERIODS: Array[String] = ["Manhã", "Tarde", "Noite", "Madrugada"]

func tick(delta: float) -> void:
    if dialogue_open or inventory_open or day > 30:
        return
    seconds += delta
    if seconds >= seconds_per_period:
        seconds -= seconds_per_period
        advance_period()

func advance_period() -> void:
    period += 1
    if period >= PERIODS.size():
        period = 0
        day += 1
        energy = minf(100.0, energy + 45.0)
    changed.emit()

func sleep() -> void:
    if day >= 30:
        day = 31
    else:
        day += 1
    period = 0
    seconds = 0.0
    hp = mini(100, hp + 30)
    energy = 100.0
    flags["talked_today"] = -1
    changed.emit()

func heal() -> bool:
    if potions <= 0 or hp >= 100:
        return false
    potions -= 1
    hp = mini(100, hp + 40)
    changed.emit()
    return true

func add_loot(kind: String) -> void:
    match kind:
        "madeira": wood += 1
        "pedra": stones += 1
        "moeda": money += 20
    changed.emit()

func gain_xp(amount: int) -> void:
    experience += amount
    changed.emit()
