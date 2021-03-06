extends Node2D

enum targets { DELIVERY, DEVIL, MOM, EXIT }
export (targets) var target = targets.DELIVERY

enum states { off, on }
var state = states.off

var cheat_enabled : bool = false

var ticks : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if target == targets.MOM:
		hide()
#	elif target == targets.DEVIL and Game.map.name != "Overworld":
#		hide()
	if target == targets.DEVIL:
		hide()


	pass # Replace with function body.


func cheat_show_compasses():
	show()
	cheat_enabled = true

#warning-ignore:unused_argument
func _process(delta):
	ticks += 1

#	if ticks % 60 == 0:
#		print(self.name, " current_destination == ", Game.player.current_destination.name)


	if cheat_enabled:
		show()

	if visible == false:
		if target == targets.EXIT and Game.stage == Game.stages.ESCAPE:
			show()
		return



	if state == states.on:
		if target == targets.DELIVERY:
			if Game.player.current_destination != null:
				var destination = Game.player.current_destination
				if is_instance_valid(destination):
					if Game.player.current_destination.has_method("get_coordinates"):
						look_at(Game.player.current_destination.get_coordinates())
					else:
						look_at(Game.player.current_destination.get_global_position())
				else:
					#push_warning("Compass can't find delivery destination. Was it queued_free?")

					Game.player.current_destination = Game.map.pizza_factory

		elif target == targets.DEVIL:
			if is_instance_valid(Game.devil):
				look_at(Game.devil.get_global_position())
			else:
				if visible:
					hide()

		elif target == targets.MOM and Game.map.name == "Underworld":
			#print(self.name ," looking for mom")
			if Game.mom != null and is_instance_valid(Game.mom):
				#print(self.name, " found mom")
				look_at(Game.mom.get_global_position())
			else:
				# might be changing to Exit
				pass

		elif target == targets.EXIT and Game.map.name == "Underworld":
			if Game.exit != null and is_instance_valid(Game.exit):
				look_at(Game.exit.get_global_position())
			else:
				#hide()
				pass
	else:
		pass
		#hide()






func turn_on():
	state = states.on

func turn_off():
	state = states.off
