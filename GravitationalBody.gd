extends Node3D

# Parâmetros do corpo
@export var mass: float = 1.0  # Massa do corpo
@export var central_body: NodePath = ""  # Nó que será o corpo central (Ex: Sol para a Terra)
@export var distance_from_central: float = 10.0  # Distância inicial do corpo central

# Variáveis internas
var velocity: Vector3 = Vector3.ZERO
var central_body_node: Node3D = null
var G: float = 1  # Constante gravitacional

# Função chamada quando o nó é inicializado
func _ready():
	# Verifica se o corpo central foi especificado corretamente
	if not central_body.is_empty():
		central_body_node = get_node(central_body)
	
	# Verifica se o corpo central foi encontrado
	if central_body_node == null:
		print("Erro")
		return

	# Calcula a velocidade orbital inicial
	_calcular_velocidade_orbital()

# Função para calcular a velocidade orbital inicial
func _calcular_velocidade_orbital():
	
	if central_body_node:
		var r_vec = global_position - central_body_node.global_position
		var r = r_vec.length()

		# Se a distância for maior que zero, calculamos a velocidade orbital
		if r > 0:
			# Velocidade orbital calculada de acordo com a gravitação universal
			var orbital_speed = sqrt( (G * central_body_node.mass) / r )
			var dir = r_vec.normalized()
			var tangent = dir.cross(Vector3.UP)  # Vetor tangencial

			# Aplica a velocidade tangencial
			velocity = tangent * orbital_speed
	
# Função chamada a cada frame 
func _physics_process(delta):
	if central_body_node == null:
		return

	# Aceleração gravitacional do corpo central
	var r_vec = central_body_node.global_position - global_position
	var distance = r_vec.length()

	if distance > 0:
		var direction = r_vec.normalized()
		var force = (G * central_body_node.mass * mass) / (distance * distance)  # Lei da gravitação universal de Newton

		# Aceleração provocada pela força gravitacional
		var acceleration = direction * force / mass

		# Atualiza a velocidade e posição
		velocity += acceleration * delta  # Acumula a aceleração de forma controlada
		global_position += velocity * delta  # Atualiza a posição com base na nova velocidade
		
func get_velocity():
	return velocity
