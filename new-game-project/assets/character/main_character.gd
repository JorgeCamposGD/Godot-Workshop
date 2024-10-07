extends CharacterBody2D

@onready
var sprite=$AnimatedSprite2D
@onready
var weaponLeft=$WeaponLeft
@onready
var weaponRight=$WeaponRight
@onready
var bullet=preload("res://assets/character/bullet/bullet.tscn")
@onready
var animationPlayer=$AnimationPlayer
var dir=Vector2()
var walking=false
var aiming=false
var cooldown_pistol=0.75
var cooldown=0
var hp=100
var invencible=false
var invencible_time=0
var dead=false
const GRAVITTY=980
func _ready() -> void:
	sprite.play("idle")
	get_node("CanvasLayer/Control/HP").text=str(hp)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	cooldown-=delta
	aiming=false
	
	if dead:
		return
	if hp<=0:
		dead=true
		sprite.play("death")
		return
	if invencible_time>0:
		invencible_time-=delta

	var direction = Input.get_axis("ui_left", "ui_right")
	dir.x=direction
	if dir.x>0:
		sprite.flip_h=false
		walking=true
	elif dir.x<0:
		sprite.flip_h=true
		walking=true
	else:
		walking=false
	if Input.is_action_pressed("shoot"):
		aiming=true
		if cooldown<=0:
			shoot()

	if(walking and not aiming):
		sprite.play("walk")
	elif(walking and aiming):
		sprite.play("walk_aiming")
	elif(aiming):
		sprite.play("aiming")
	else:
		sprite.play("idle")

	
	if not is_on_floor():
		pass
	velocity.y += GRAVITTY*delta
	velocity.x =dir.x*450
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y -= 550
	move_and_slide()
	
func shoot():
	var bullet=self.bullet.instantiate()
	bullet.set_direction(dir)
	get_parent().add_child(bullet)
	if sprite.flip_h:
		bullet.global_position= weaponLeft.global_position
		bullet.set_direction(Vector2(-1,0))
	else:
		bullet.global_position= weaponRight.global_position
		bullet.set_direction(Vector2(1,0))
	cooldown=cooldown_pistol

func dano(dano):
	if dead:
		return
	animationPlayer.play("Hurt")
	if invencible:
		return
	hp-=dano
	get_node("CanvasLayer/Control/HP").text=str(hp)
	invencible_time=0.5
