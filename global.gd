extends Node


var boosts = 1
var explostr = 1000
var fuseval = 100
var explocost = 15
var regenrate = .3
var regentime = 1
var gravity = 1200
var maxhealth = 3
var coins = 0
var level = 1
var movementspeed = 500
var extracoins = 0
var deathpenalty = 30
var uncontrol = false
var coinhealth = false
var sandbox = false
func reset():
	boosts = 1
	explostr = 300
	fuseval = 10
	explocost = 15
	regentime = 1
	regenrate = .3
	maxhealth = 3
	coins = 0
	level = 1
	movementspeed = 500
	extracoins = 0
	deathpenalty = 30
	uncontrol = false
	coinhealth = false
	sandbox = false


func booststr():
	explostr *= 1.1
