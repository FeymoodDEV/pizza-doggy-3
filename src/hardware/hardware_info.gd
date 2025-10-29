extends Resource
class_name HardwareInfo

@export var resources : Dictionary[StringName, Dictionary] = {
	&"silica": {&"harvest_count": 20, &"harvest_time": 15.0},
	&"copper": {&"harvest_count": 20, &"harvest_time": 15.0},
	&"glass": {&"harvest_count": 15, &"harvest_time": 10.0},
	&"plastic": {&"harvest_count": 10, &"harvest_time": 30.0},
	&"gold": {&"harvest_count": 10, &"harvest_time": 40.0},
	&"aluminum": {&"harvest_count": 10, &"harvest_time": 40.0},
	&"hafnium": {&"harvest_count": 5, &"harvest_time": 60.0},
}

@export var recipes : Dictionary[StringName, Dictionary] = {
	&"new_drone": {&"harvest_time": 5, &"copper": 10}
}
