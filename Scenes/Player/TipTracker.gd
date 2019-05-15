extends HBoxContainer

var ticks : int = 0

var time_remaining : float = 60.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#warning-ignore:unused_argument
func _process(delta):
	ticks += 1

	if ticks % 20 == 0:
		var cash_string = "$" + "%6.2f" % Game.player.cash
		$CashOnHand.set_text(cash_string)

	if Game.player.current_destination != Game.map.pizza_factory:
		time_remaining -= delta
		update()

	$PizzaAmmo.set_value(Game.player.pizza_ammo)

func _draw():
	var clock_rect = $StopWatch
	var clock_size : Vector2 = clock_rect.get_size()
	var clock_pos = clock_rect.get_position() + clock_size/2
	var radius = clock_size.x / 2
	draw_circle(clock_pos , radius, Color(1, 1, 1, .25))
	var second_pos = clock_pos + Vector2.UP.rotated(time_remaining / 60.0 * 2 * PI) * radius
	draw_line(clock_pos, second_pos, Color.black, 1.0, false  )

func reset_clock():
	time_remaining = 60.0
	update()

