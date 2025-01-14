extends Node

#region Stats
@export_category("Stats")
@export var health : Health
@export var baseSpeed : float = 30
@export var startRange : float = 200
@export var damagedEffect : DamagedEffect

@onready var projectileContainer : Node2D = WorldManager.projectileContainer
@onready var playerTarget : CharacterBody2D = PlayerManager.player
@onready var startingPosition : Vector2 = self.position
@onready var centerNode : Vector2 = self.position + Vector2.DOWN * 170
@onready var targetPosition : Vector2 = centerNode

@onready var corners : Array[Vector2] = [Vector2(-80, -50), Vector2(80, -50), Vector2(80, 50), Vector2(-80, 50)]
@onready var cornersCopy = corners.duplicate()
@onready var moveToCornerTimer : Cooldown = Cooldown.new(7, setNewCorner)
@onready var phaseTransitionTimer : Cooldown = Cooldown.new(2, changePhase.bind(BOSS_PHASES.PHASE_2), true) 
@onready var currentSpeed = baseSpeed

enum BOSS_PHASES {IDLE, START, PHASE_1, PHASE_2, PHASE_3}
var currentPhase : BOSS_PHASES = BOSS_PHASES.IDLE
var attackSpeed = 1
var membersAlive = 0
#endregion

#region Machine Gun
@export_category("Machine Gun")
@export var machineGunHealth : Health
@export var machineGunDamagedEffect : DamagedEffect
@export var projectileTemplate : PackedScene
@export var machineGunCooldown : float = 2
@export var machineGunReloadCooldown : float = 1
@export var machineGunBurstLength : int = 10
@onready var reloadMachineGunTimer : Cooldown = Cooldown.new(machineGunReloadCooldown, reloadMachineGun)
@onready var machineGunShootingTimer : Cooldown = Cooldown.new(machineGunCooldown, shootMachineGun)
var machineGunShots : int
#endregion

@export_category("Flamethrower")
@export var flamethrowerHealth : Health
@export var flamethrowerDamagedEffect : DamagedEffect
@export var flamethrowerShootingCooldown : float = 5
@onready var flamethrowerShootingTimer : Cooldown = Cooldown.new(flamethrowerShootingCooldown, shootFlamethrower)

@export_category("Artillery")
@export var artilleryHealth : Health
@export var artilleryDamagedEffect  : DamagedEffect
@export var timedDamageAreaTemplate : PackedScene
@export var artilleryShootingCooldown : float = 8
@onready var artilleryShootingTimer : Cooldown = Cooldown.new(artilleryShootingCooldown, shootArtillery)

func _ready():
	health.onHit.connect(damagedEffect.onHit)
	health.onDeath.connect(onDeath)
	
	machineGunHealth.onHit.connect(machineGunDamagedEffect.onHit)
	machineGunHealth.onDeath.connect(onMachineGunDeath)

	flamethrowerHealth.onHit.connect(flamethrowerDamagedEffect.onHit)
	flamethrowerHealth.onDeath.connect(onFlamethrowerDeath)

	artilleryHealth.onHit.connect(artilleryDamagedEffect.onHit)
	artilleryHealth.onDeath.connect(onArtilleryDeath)
	reset()

func onDeath():
	queue_free()

func onMemberDeath():
	currentSpeed *= 1.5
	attackSpeed *= 2
	membersAlive -= 1
	if membersAlive == 0:
		changePhase(BOSS_PHASES.PHASE_3)

func onMachineGunDeath():
	onMemberDeath()
	machineGunHealth.get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	machineGunHealth.get_parent().visible = false
	# rifle drop

func onFlamethrowerDeath():
	onMemberDeath()
	flamethrowerHealth.get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	flamethrowerHealth.get_parent().visible = false
	# flamethrower drop

func onArtilleryDeath():
	onMemberDeath()
	artilleryHealth.get_parent().process_mode = Node.PROCESS_MODE_DISABLED
	artilleryHealth.get_parent().visible = false
	# rocket launcher drop

func _process(delta):
	match currentPhase:
		BOSS_PHASES.IDLE:
			# START SHOULD BE ENABLED THROUGH BOSS TRIGGER!
			if self.position.distance_to(playerTarget.position) < startRange:
				changePhase(BOSS_PHASES.START)
		BOSS_PHASES.START:
			startPhase(delta)
		BOSS_PHASES.PHASE_1:
			phaseOne(delta)
		BOSS_PHASES.PHASE_2:
			phaseTwo(delta)
		BOSS_PHASES.PHASE_3:
			phaseThree(delta)
	
func changePhase(phase : BOSS_PHASES):
	currentPhase = phase
	print(BOSS_PHASES.keys()[currentPhase])

	match currentPhase:
		BOSS_PHASES.IDLE:
			membersAlive = 3
			self.position = startingPosition
			health.invulnerable = true
			machineGunHealth.invulnerable = true
			flamethrowerHealth.invulnerable = true
			artilleryHealth.invulnerable = true
		BOSS_PHASES.START:
			targetPosition = centerNode
		BOSS_PHASES.PHASE_1:
			machineGunHealth.invulnerable = false
			flamethrowerHealth.invulnerable = false
			artilleryHealth.invulnerable = false
		BOSS_PHASES.PHASE_2:
			setNewCorner()
		BOSS_PHASES.PHASE_3:
			health.invulnerable = false

func moveToTarget(delta):
	self.position = self.position.move_toward(targetPosition, delta * currentSpeed)

func startPhase(delta):
	moveToTarget(delta)
	if self.position == targetPosition:
		changePhase(BOSS_PHASES.PHASE_1)

func phaseOne(delta):
	attackLoop(delta)
	phaseTransitionTimer.tick(delta)

func phaseTwo(delta):
	attackLoop(delta)
	moveToTarget(delta)
	if self.position == targetPosition:
		moveToCornerTimer.tick(delta)

func phaseThree(delta):
	moveToTarget(delta)
	if self.position == targetPosition:
		moveToCornerTimer.tick(delta)

func attackLoop(delta):
	delta *= attackSpeed
	if machineGunHealth.get_parent().visible:
		shootMachineGunBurst(delta)
	if flamethrowerHealth.get_parent().visible:
		flamethrowerShootingTimer.tick(delta)
	if artilleryHealth.get_parent().visible:
		artilleryShootingTimer.tick(delta)

func shootMachineGunBurst(delta):
	if machineGunShots < machineGunBurstLength:
		machineGunShootingTimer.tick(delta)
	else:
		reloadMachineGunTimer.tick(delta)

func reloadMachineGun():
	machineGunShots = 0

func shootMachineGun():
	machineGunShots += 1
	var projectile : EnemyProjectile = projectileTemplate.instantiate()
	projectileContainer.add_child(projectile)
	projectile.position = machineGunHealth.global_position
	projectile.setup((playerTarget.position - self.position).normalized())

func shootFlamethrower():
	var aimDir = (playerTarget.position - self.position).normalized()
	for i in 5:
		var projectile : EnemyProjectile = projectileTemplate.instantiate()
		projectileContainer.add_child(projectile)
		projectile.position = flamethrowerHealth.global_position
		projectile.setup(aimDir.rotated(deg_to_rad(-20 + i * 10)))

func shootArtillery():
	for i in 5:
		var enemyTimedDamageArea : EnemyTimedDamageArea = timedDamageAreaTemplate.instantiate()
		projectileContainer.add_child(enemyTimedDamageArea)
		var angle := randf_range(0, TAU)
		var distance := randi_range(0, 70)
		var randomPos = playerTarget.position + distance * Vector2.from_angle(angle)
		enemyTimedDamageArea.position = randomPos
		enemyTimedDamageArea.setup(randf_range(0, 1), 2)

func setNewCorner():
	if corners.is_empty():
		corners = cornersCopy.duplicate()
		corners.shuffle()

	var randIndex = randi() % corners.size()
	if self.position == self.position + corners[randIndex]:
		corners.remove_at(randIndex)
	
	targetPosition = centerNode + corners.pop_front()

func reset():
	changePhase(BOSS_PHASES.IDLE)

	corners.shuffle()
	currentSpeed = baseSpeed
	attackSpeed = 1
	health.reset()
	machineGunHealth.reset()
	flamethrowerHealth.reset()
	artilleryHealth.reset()

	phaseTransitionTimer.reset()
	reloadMachineGunTimer.reset()
	machineGunShootingTimer.reset()
	flamethrowerShootingTimer.reset()
	artilleryShootingTimer.reset()

	machineGunHealth.get_parent().process_mode = Node.PROCESS_MODE_INHERIT
	machineGunHealth.get_parent().visible = true
	flamethrowerHealth.get_parent().process_mode = Node.PROCESS_MODE_INHERIT
	flamethrowerHealth.get_parent().visible = true
	artilleryHealth.get_parent().process_mode = Node.PROCESS_MODE_INHERIT
	artilleryHealth.get_parent().visible = true
