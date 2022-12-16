extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const GameOverScreen = preload("res://UI/GameOverScreen.tscn")
const hit = preload("res://Overlap/Hitbox.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 20
export var FRICTION = 600
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats_p = PlayerStats

var state = CHASE

#onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
#onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitbox = $Hitbox

func _ready():
	#state = pick_random_state([IDLE, WANDER])
	state = IDLE
	animationTree.active = true
	hitbox.knockback_vector = roll_vector
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			seek_player()
			animationState.travel("Idle")
			#velocity = velocity.move_toward(Vector2.100 * MAX_SPEED, FRICTION * delta)
			
			#if wanderController.get_time_left() == 0:
				#update_wander()
				
		#WANDER:
			#seek_player()
			#if wanderController.get_time_left() == 0:
				#update_wander()
			#accelerate_towards_point(wanderController.target_position, delta)
			#if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				#update_wander()
			
		CHASE:
			var input_vector = Vector2.ZERO
			var player = playerDetectionZone.player
			if player != null:
				#animationTree.set("parameters/Idle/blend_position", input_vector)
				#animationTree.set("parameters/Run/blend_position", input_vector)
				#animationTree.set("parameters/Attack/blend_position", input_vector)
				animationState.travel("Run")
				#velocity = velocity.move_toward(Vector2.ZERO * MAX_SPEED, ACCELERATION * delta)
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 200
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	
	animationState.travel("Attack")
	knockback = area.knockback_vector * 200
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	
	

func _on_Stats_no_health():
	queue_free()
	if stats_p.max_health < 8:
		stats_p.max_health += 1
		stats_p.health += 1
		
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")
