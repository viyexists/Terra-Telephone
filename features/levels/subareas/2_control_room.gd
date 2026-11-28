extends Subarea

var exploded: bool = false

var neutronPopulation: float = 555555.0 # 200MWth
const ratedNeutronPopulation: float = 10000000 # 100% Rated power (3600MWth)
const explosionNeutronPopulation: float = 83333333 # 833% Rated power (30,000MWth)
const generationTime: float = 0.06

var AZ5Initiated: bool = false
var timeSinceAZ5Initiated: float = 0.0
const graphiteDisplacementTime: float = 3.0 # seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Cheap reactor physics
# Yes, I condensed the entirety of R304B 1.7 and R304P 2.1 into 12 lines of gdscript
func _physics_process(delta: float) -> void:
	var keff = 1
	if AZ5Initiated and timeSinceAZ5Initiated < graphiteDisplacementTime:
		keff = 1.1
	elif AZ5Initiated:
		timeSinceAZ5Initiated += delta
		keff = 0.9
	keff += randf_range(-0.01, 0.01)
	neutronPopulation *= exp((keff - 1.0) * delta / generationTime)
	if not AZ5Initiated:
		neutronPopulation = clamp(neutronPopulation, 550000, 585555)
	if neutronPopulation > explosionNeutronPopulation:
		exploded = true
	
	print("%.2f %%" % (neutronPopulation * 100.0/ratedNeutronPopulation))
