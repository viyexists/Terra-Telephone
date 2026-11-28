class_name level_2_chernobyl_control_room
extends Subarea

static var exploded: bool = false
var set_exploded: bool = false

var neutronPopulation: float = 555555.0 # 200MWth
const ratedNeutronPopulation: float = 10000000 # 100% Rated power (3600MWth)
const explosionNeutronPopulation: float = 83333333 # 833% Rated power (30,000MWth)
const generationTime: float = 0.06

var annLit: bool = false
var annTime: float = 0.0

static var AZ5Initiated: bool = false
var timeSinceAZ5Initiated: float = 0.0
const graphiteDisplacementTime: float = 3.0 # seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# preload annunciators
var az5_unlit = preload("res://assets/custom/annunciators/az5_unlit.png")
var az5_lit = preload("res://assets/custom/annunciators/az5_lit.png")
var lar_unlit = preload("res://assets/custom/annunciators/lar_unlit.png")
var lar_l1 = preload("res://assets/custom/annunciators/lar_l1.png")
var lar_l2 = preload("res://assets/custom/annunciators/lar_l2.png")

# preload mosaic panels
var panel_unlit = preload("res://assets/custom/mosaic/mosaic_panel_unlit.png")
var panel_normal = preload("res://assets/custom/mosaic/mosaic_panel_normal.png")
var panel_l1 = preload("res://assets/custom/mosaic/mosaic_panel_l1.png")
var panel_l2 = preload("res://assets/custom/mosaic/mosaic_panel_l2.png")
var panel_l3 = preload("res://assets/custom/mosaic/mosaic_panel_l3.png")
var panel_l4 = preload("res://assets/custom/mosaic/mosaic_panel_l4.png")
var panelTextures = [panel_unlit, panel_normal, panel_l1, panel_l2, panel_l3, panel_l4]
var panelSetpoint = [0.0, 0.2, 1.08, 1.25, 2.0, 3.0]

# Cheap reactor physics
# Yes, I condensed the entirety of R304B 1.7 and R304P 2.1 into 12 lines of gdscript
func _physics_process(delta: float) -> void:
	var keff = 1
	if AZ5Initiated:
		timeSinceAZ5Initiated += delta
	if AZ5Initiated and timeSinceAZ5Initiated < graphiteDisplacementTime:
		keff = 1.1
	elif AZ5Initiated:
		keff = 1.05
	if exploded:
		keff = 0.9
	keff += randf_range(-0.01, 0.01)
	neutronPopulation *= exp((keff - 1.0) * delta / generationTime)
	if not AZ5Initiated:
		neutronPopulation = clamp(neutronPopulation, 550000, 585555)
	if neutronPopulation > explosionNeutronPopulation and not set_exploded:
		exploded = true
		set_exploded = true
		player.get_node("Camera2D").add_trauma(1.0)
	neutronPopulation = min(neutronPopulation, 100000000) # arbitrary clamp so we dont get NaN
	
	var insertion = clamp(timeSinceAZ5Initiated / 18.0, 0.0, 1.0) if AZ5Initiated else 0.0
	for needle in $Gauges.get_children():
		needle.rotation_degrees = lerp(400.0, 180.0, insertion)
	
	var level = 0
	for i in panelSetpoint.size():
		if neutronPopulation / ratedNeutronPopulation >= panelSetpoint[i]: level = i
	$MosaicPanelRight.texture = panelTextures[level]
	
	annTime += delta
	if annTime > 0.16:
		annTime = 0.0
		annLit = not annLit
		
		$POWER.text = "%05d" % ((neutronPopulation / ratedNeutronPopulation) * 3600.0)
		
	if annLit:
		if AZ5Initiated:
			$az5Ann.texture = az5_lit
		if neutronPopulation / ratedNeutronPopulation > 1.25:
			$larAnn.texture = lar_l2
		elif neutronPopulation / ratedNeutronPopulation > 1.08:
			$larAnn.texture = lar_l1
	else:
		$az5Ann.texture = az5_unlit
		$larAnn.texture = lar_unlit
	
	print("%.2f %%" % (neutronPopulation * 100.0/ratedNeutronPopulation))
