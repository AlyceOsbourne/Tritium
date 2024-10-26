class_name MechData

class Data:
    var _data: MechData

    func _init(mech_data: MechData) -> void:
        self._data = mech_data

    func _set(property: StringName, value: Variant) -> bool:
        if self[property] is float and is_equal_approx(self[property], value):
            return true
        elif self[property] == value:
            return true

        self[property] == value
        _data.data_updated.emit.call_deferred()

        return true

class BasicProperties extends Data:
    @export var name: String = "Clunker V1"
    @export var home_position: Vector2i = Vector2i.ZERO
    @export var mech_position: Vector2i = Vector2i.ZERO
    @export var mech_target: Vector2i = Vector2i.ZERO
    @export_range(0, 1, 0.1) var power: float = 1
    @export_range(0, 1, 0.1) var integrity: float = 1
    @export_range(-10, 120, 5) var temperature: float = 30

class ChassisProperties extends Data:
    @export var chassis_weight: int = 0
    @export var chassis_max_weight: int = 1000
    @export var chassis_type: ChassisType = ChassisType.MEDIUM
    @export var arm_type: ArmType = ArmType.STANDARD
    @export var legs_type: LegsType = LegsType.BIPEDAL
    @export var head_type: HeadType = HeadType.STANDARD

class StateProperties extends Data:
    @export var current_state: MechState = MechState.IDLE
    @export var role: MechRole = MechRole.GENERAL

class SensorAndTools extends Data:
    @export var sensor: Sensor = Sensor.CAMERA
    @export var left_tool: Tool = Tool.NONE
    @export var right_tool: Tool = Tool.NONE

class Upgrades extends Data:
    @export var building_upgrades: BuildingUpgrade = BuildingUpgrade.NONE
    @export var farming_upgrades: FarmingUpgrade = FarmingUpgrade.NONE
    @export var mining_upgrades: MiningUpgrade = MiningUpgrade.NONE
    @export var surveying_upgrades: SurveyingUpgrade = SurveyingUpgrade.NONE
    @export var logistics_upgrades: LogisticsUpgrade = LogisticsUpgrade.NONE
    @export var maintenance_upgrades: MaintenanceUpgrade = MaintenanceUpgrade.NONE
    @export var combat_upgrades: CombatUpgrade = CombatUpgrade.NONE
    @export var exploration_upgrades: ExplorationUpgrade = ExplorationUpgrade.NONE

class CombatProperties extends Data:
    @export var weapon_type: WeaponType = WeaponType.NONE
    @export var ammo_type: AmmoType = AmmoType.NONE

class PerformanceProperties extends Data:
    @export var speed: float = 10.0
    @export var armor: float = 50.0
    @export var agility: float = 5.0

enum MechState {
    IDLE,
    MOVING,
    COMBAT,
    DISABLED,
    REPAIRING,
    CHARGING,
    EXPLORING
}

enum Sensor {
    NONE,
    CAMERA,
    RADAR,
    SONAR,
    LIDAR,
    INFRARED
}

enum Tool {
    NONE,
    DRILL,
    CHAINSAW,
    BUILDING_TOOL,
    FARMING_TOOL,
    MINING_TOOL,
    SURVEYING_TOOL,
    LOGISTICS_TOOL,
    MAINTENANCE_TOOL,
    WELDING_TOOL,
    CUTTING_TOOL
}

enum MechRole {
    NONE,
    GENERAL,
    BUILDING,
    FARMING,
    MINING,
    SURVEYING,
    LOGISTICS,
    MAINTENANCE,
    COMBAT,
    EXPLORATION
}

enum BuildingUpgrade {
    NONE,
    BASIC_CONSTRUCTION,
    ADVANCED_CONSTRUCTION,
    AUTOMATED_CONSTRUCTION
}

enum FarmingUpgrade {
    NONE,
    BASIC_FARMING,
    ADVANCED_FARMING,
    HYDROPONICS
}

enum MiningUpgrade {
    NONE,
    BASIC_MINING,
    ADVANCED_MINING,
    DEEP_MINING
}

enum SurveyingUpgrade {
    NONE,
    BASIC_SURVEYING,
    ADVANCED_SURVEYING,
    GEOPHYSICAL_SURVEYING
}

enum LogisticsUpgrade {
    NONE,
    BASIC_LOGISTICS,
    ADVANCED_LOGISTICS,
    AUTOMATED_LOGISTICS
}

enum MaintenanceUpgrade {
    NONE,
    BASIC_MAINTENANCE,
    ADVANCED_MAINTENANCE,
    SELF_REPAIR
}

enum CombatUpgrade {
    NONE,
    LIGHT_ARMOR,
    HEAVY_ARMOR,
    ADVANCED_WEAPONRY
}

enum ExplorationUpgrade {
    NONE,
    LONG_RANGE_SCANNER,
    TERRAIN_ADAPTATION,
    EXTREME_ENVIRONMENT_RESISTANCE
}

enum ChassisType {
    LIGHT,
    MEDIUM,
    HEAVY
}

enum ArmType {
    NONE,
    STANDARD,
    HEAVY,
    PRECISION
}

enum LegsType {
    BIPEDAL,
    QUADRUPEDAL,
    TRACKS,
    WHEELS
}

enum HeadType {
    NONE,
    STANDARD,
    SENSOR_HEAVY,
    ARMORED
}

enum WeaponType {
    NONE,
    LASER,
    MACHINE_GUN,
    ROCKET_LAUNCHER,
    FLAMETHROWER
}

enum AmmoType {
    NONE,
    ENERGY,
    BULLETS,
    ROCKETS,
    FUEL
}

enum PerformanceStat {
    SPEED,
    ARMOR,
    AGILITY
}

signal data_updated

var debug: bool = false

var system: BasicProperties = BasicProperties.new(self)
var chassis: ChassisProperties = ChassisProperties.new(self)
var state: StateProperties = StateProperties.new(self)
var equipment: SensorAndTools = SensorAndTools.new(self)
var upgrades: Upgrades = Upgrades.new(self)
var combat: CombatProperties = CombatProperties.new(self)
var performance: PerformanceProperties = PerformanceProperties.new(self)

@export_multiline var _code: String = """# Mecha boot script

fn main(){
    if(mech.debug){
       systems_check()
    }
    return OK;
}

fn power_systems_check() {
    assert(mech.system.power, "Mech is out of power.")
    if (mech.system.power < 0.3) {printerr("Mech power reserves low.")}
    assert(mech.state.current_state != MechState.DISABLED)
}

fn safety_systems_check() {
    assert(mech.system.integrity > 0, "Mech requires urgent maintenance.")
    if (mech.system.integrity < 0.3) {printerr("Mech integrity low.")}
    assert(mech.system.temperature < 100, "Mech is overheated.")
    if (mech.system.temperature > 80) {printerr("Mech temperature nearing critical levels.")}
    assert(mech.system.temperature > 0, "Mech is frozen.")
}

fn chassis_check() {
    assert(mech.chassis.chassis_weight <= mech.chassis.chassis_max_weight, "Mech is overweight.")
    if (mech.chassis.chassis_weight > (mech.chassis.chassis_max_weight * 0.8)) {print("Mech is reaching weight limits.")}
}

fn equipment_check() {
    assert(mech.equipment.sensor != Sensor.NONE, "Mech has no sensor equipped.")
    if (mech.equipment.left_tool == Tool.NONE) {printerr("Warning: Mech has no left tool equipped.")}
    if (mech.equipment.right_tool == Tool.NONE) {printerr("Warning: Mech has no right tool equipped.")}
}

fn systems_check() {
    print("Running checks for: " + mech.system.name)

    for (check in [
        power_systems_check,
        safety_systems_check,
        chassis_check,
        equipment_check
    ]){
        check()
    }

    print("All Systems Nominal. Can proceed with mission.")
}"""

func move_to(position: Vector2i):
    system.mech_target = position
    state.current_state = MechState.MOVING
    data_updated.emit.call_deferred()

func engage_combat():
    state.current_state = MechState.COMBAT

func disable_mech():
    state.current_state = MechState.DISABLED
    data_updated.emit.call_deferred()

func start_mech():
    state.current_state = MechState.IDLE
    data_updated.emit.call_deferred()

func set_mech_name(name: String):
    if name != system.name:
        system.name = name
        data_updated.emit.call_deferred()

func discard_weapon():
    combat.weapon_type = WeaponType.NONE
    combat.ammo_type = AmmoType.NONE
    data_updated.emit.call_deferred()

func _to_string() -> String:
    var display: String = ""
    display += "MECH STATUS \n"
    display += "Power Level: %.2f\n" % system.power
    display += "Integrity: %.2f\n" % system.integrity
    display += "Temperature: %.2f°C\n" % system.temperature
    display += "Current State: %s\n" % str(MechState.find_key(state.current_state))
    display += "Role: %s\n" % str(MechRole.find_key(state.role))
    display += "Building Upgrades: %s\n" % str(BuildingUpgrade.find_key(upgrades.building_upgrades))
    display += "Farming Upgrades: %s\n" % str(FarmingUpgrade.find_key(upgrades.farming_upgrades))
    display += "Mining Upgrades: %s\n" % str(MiningUpgrade.find_key(upgrades.mining_upgrades))
    display += "Surveying Upgrades: %s\n" % str(SurveyingUpgrade.find_key(upgrades.surveying_upgrades))
    display += "Logistics Upgrades: %s\n" % str(LogisticsUpgrade.find_key(upgrades.logistics_upgrades))
    display += "Maintenance Upgrades: %s\n" % str(MaintenanceUpgrade.find_key(upgrades.maintenance_upgrades))
    display += "Combat Upgrades: %s\n" % str(CombatUpgrade.find_key(upgrades.combat_upgrades))
    display += "Exploration Upgrades: %s\n" % str(ExplorationUpgrade.find_key(upgrades.exploration_upgrades))
    display += "Chassis Type: %s\n" % str(ChassisType.find_key(chassis.chassis_type))
    display += "Arm Type: %s\n" % str(ArmType.find_key(chassis.arm_type))
    display += "Legs Type: %s\n" % str(LegsType.find_key(chassis.legs_type))
    display += "Head Type: %s\n" % str(HeadType.find_key(chassis.head_type))
    display += "Weapon Type: %s\n" % str(WeaponType.find_key(combat.weapon_type))
    display += "Ammo Type: %s\n" % str(AmmoType.find_key(combat.ammo_type))
    display += "Speed: %.2f\n" % performance.speed
    display += "Armor: %.2f\n" % performance.armor
    display += "Agility: %.2f\n" % performance.agility
    display += "Left Tool: %s\n" % str(Tool.find_key(equipment.left_tool))
    display += "Right Tool: %s\n" % str(Tool.find_key(equipment.right_tool))
    return display

func _bind(settings: InterpreterSettings):
    settings.bind_variable("mech", self)
    settings.bind_variable("MechState", MechState)
    settings.bind_variable("Sensor", Sensor)
    settings.bind_variable("Tool", Tool)
    settings.bind_variable("MechRole", MechRole)
    settings.bind_variable("BuildingUpgrade", BuildingUpgrade)
    settings.bind_variable("FarmingUpgrade", FarmingUpgrade)
    settings.bind_variable("MiningUpgrade", MiningUpgrade)
    settings.bind_variable("SurveyingUpgrade", SurveyingUpgrade)
    settings.bind_variable("LogisticsUpgrade", LogisticsUpgrade)
    settings.bind_variable("MaintenanceUpgrade", MaintenanceUpgrade)
    settings.bind_variable("CombatUpgrade", CombatUpgrade)
    settings.bind_variable("ExplorationUpgrade", ExplorationUpgrade)
    settings.bind_variable("ChassisType", ChassisType)
    settings.bind_variable("ArmType", ArmType)
    settings.bind_variable("LegsType", LegsType)
    settings.bind_variable("HeadType", HeadType)
    settings.bind_variable("WeaponType", WeaponType)
    settings.bind_variable("AmmoType", AmmoType)
    settings.bind_variable("PerformanceStat", PerformanceStat)
