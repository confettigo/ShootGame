extends Node

#region Stats
@export_category("Stats")
@export var health : Health
@export var speed : float = 30
@export var baseDamageTime : float = 1
@export var startRange : float = 200

@onready var projectileContainer : Node2D = WorldManager.projectileContainer
@onready var playerTarget : CharacterBody2D = PlayerManager.player
var startingPosition : Vector2
var targetPosition : Vector2
var damagedTimer : float = 0
var isDamaged = true

enum BOSS_PHASES {IDLE, START, PHASE_1, PHASE_2}
var currentPhase : BOSS_PHASES = BOSS_PHASES.IDLE

var centerNode : Vector2
var corners : Array[Vector2]
var cornersCopy
@onready var moveToCornerTimer : Cooldown = Cooldown.new(7, setNewCorner)
@onready var phaseTransitionTimer : Cooldown = Cooldown.new(2, changePhase.bind(BOSS_PHASES.PHASE_2), true) 
#endregion

#region Machine Gun
@export_category("Machine Gun")
@export var projectileTemplate : PackedScene
@export var machineGunCooldown : float = 2
@export var machineGunReloadCooldown : float = 1
@export var machineGunBurstLength : int = 10
@onready var reloadMachineGunTimer : Cooldown = Cooldown.new(machineGunReloadCooldown, reloadMachineGun)
@onready var machineGunShootingTimer : Cooldown = Cooldown.new(machineGunCooldown, shootMachineGun)
var machineGunShots : int
#endregion

@export_category("Flamethrower")
@export var flamethrowerShootingCooldown : float = 5
@onready var flamethrowerShootingTimer : Cooldown = Cooldown.new(flamethrowerShootingCooldown, shootFlamethrower)

@export_category("Artillery")
@export var timedDamageAreaTemplate : PackedScene
@export var artilleryShootingCooldown : float = 8
@onready var artilleryShootingTimer : Cooldown = Cooldown.new(artilleryShootingCooldown, shootArtillery)

func _ready():
	startingPosition = self.position
	centerNode = self.position + Vector2.DOWN * 170
	corners.append(centerNode + Vector2(-80, -50)) # top left
	corners.append(centerNode + Vector2(80, -50)) # top right
	corners.append(centerNode + Vector2(80, 50)) # bottom right
	corners.append(centerNode + Vector2(-80, 50)) # bottom left
	corners.shuffle()
	cornersCopy = corners.duplicate()
	health.onHit.connect(onHit)
	health.onDeath.connect(onDeath)

	reset()

func onHit():
	isDamaged = true
	damagedTimer = baseDamageTime

func onDeath():
	queue_free()

func _process(delta):
	if isDamaged:
		if damagedTimer > 0:
			damagedTimer -= delta
			# change this to an animation
			self.modulate.a = 0.3 if Engine.get_frames_drawn() % 10 == 0 else 1.0
		else:
			self.modulate.a = 1.0
			isDamaged = false

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
	
func changePhase(phase : BOSS_PHASES):
	currentPhase = phase
	print(BOSS_PHASES.keys()[currentPhase])

	match currentPhase:
		BOSS_PHASES.IDLE:
			pass
		BOSS_PHASES.START:
			targetPosition = centerNode
			pass
		BOSS_PHASES.PHASE_1:
			
			health.invulnerable = false
		BOSS_PHASES.PHASE_2:
			setNewCorner()

func startPhase(delta):
	self.position = self.position.move_toward(targetPosition, delta * speed)
	if self.position == targetPosition:
		changePhase(BOSS_PHASES.PHASE_1)

func phaseOne(delta):
	attackLoop(delta)
	phaseTransitionTimer.tick(delta)

func phaseTwo(delta):
	attackLoop(delta)
	self.position = self.position.move_toward(targetPosition, delta * speed)
	if self.position == targetPosition:
		moveToCornerTimer.tick(delta)

func attackLoop(delta):
	shootMachineGunBurst(delta)
	flamethrowerShootingTimer.tick(delta)
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
	projectile.position = self.position
	projectile.setup((playerTarget.position - self.position).normalized())

func shootFlamethrower():
	var aimDir = (playerTarget.position - self.position).normalized()
	for i in 6:
		var projectile : EnemyProjectile = projectileTemplate.instantiate()
		projectileContainer.add_child(projectile)
		projectile.position = self.position
		projectile.setup(aimDir.rotated(deg_to_rad(-30 + i * 10)))

func shootArtillery():
	for i in 10:
		var enemyTimedDamageArea : EnemyTimedDamageArea = timedDamageAreaTemplate.instantiate()
		projectileContainer.add_child(enemyTimedDamageArea)
		var angle := randf_range(0, TAU)
		var distance := randi_range(0, 70)
		var randomPos = playerTarget.position + distance * Vector2.from_angle(angle)
		enemyTimedDamageArea.position = randomPos
		enemyTimedDamageArea.setup()

func setNewCorner():
	if corners.is_empty():
		corners = cornersCopy.duplicate()
		corners.shuffle()

	var randIndex = randi() % corners.size()
	if self.position == corners[randIndex]:
		corners.remove_at(randIndex)
	
	targetPosition = corners.pop_front()

func reset():
	currentPhase = BOSS_PHASES.IDLE
	self.position = startingPosition
	targetPosition = centerNode
	damagedTimer = 0
	health.invulnerable = true
	health.reset()
	phaseTransitionTimer.reset()
	reloadMachineGunTimer.reset()
	machineGunShootingTimer.reset()
	flamethrowerShootingTimer.reset()
	artilleryShootingTimer.reset()
