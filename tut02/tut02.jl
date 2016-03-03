using GLFW
using ModernGL

function key_callback(window, key, scancode, action, mode)
	if key == GLFW.KEY_ESCAPE && action == GLFW.PRESS
		GLFW.SetWindowShouldClose(window, true)
	end
end

function main()
	GLFW.Init()
	GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
	GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)
	GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
	GLFW.WindowHint(GLFW.RESIZABLE, false)

	window = GLFW.CreateWindow(800, 600, "Tutorial 1")
	GLFW.MakeContextCurrent(window)
	glViewport(0, 0, 800, 600);

	GLFW.SetKeyCallback(window, key_callback)

	triangle = GLfloat[-0.5, -0.5, 0.0,
		0.5, -0.5, 0.0,
		0.0, 0.5, 0.0]
	
	VBO = GLuint[0]
	glGenBuffers(1, VBO)
	VBO = VBO[]
	glBindBuffer(GL_ARRAY_BUFFER, VBO)
	glBufferData(GL_ARRAY_BUFFER, sizeof(triangle), triangle, GL_STATIC_DRAW)
	
	VAO = GLuint[0]
	glGenVertexArrays(1, VAO)
	VAO = VAO[]
	glBindVertexArray(VAO)

	const vsh = "
	#version 330 core
	  
	layout (location = 0) in vec3 position;

	void main()
	{
		gl_Position = vec4(position.x, position.y, position.z, 1.0);
	}"

	vertexShader = GLuint[0]
	vertexShader = glCreateShader(GL_VERTEX_SHADER)::GLuint
	glShaderSource(vertexShader, 1, convert(Ptr{UInt8}, pointer([convert(Ptr{GLchar}, pointer(vsh))])), C_NULL)
	glCompileShader(vertexShader)
	success = GLint[0]
	glGetShaderiv(vertexShader, GL_COMPILE_STATUS, success)
	if success[] != GL_TRUE
		println("Shader compiling error")
	end

	const csh = "
	#version 330 core

	out vec4 color;

	void main()
	{
	    color = vec4(1.0f, 0.5f, 0.2f, 1.0f);
	}
	"
	fragmentShader = GLuint[0]
	fragmentShader = glCreateShader(GL_FRAGMENT_SHADER)::GLuint
	glShaderSource(fragmentShader, 1, convert(Ptr{UInt8}, pointer([convert(Ptr{GLchar}, pointer(csh))])), C_NULL)
	glCompileShader(fragmentShader)


	shaderProgram = GLuint[0]
	shaderProgram = glCreateProgram()
	glAttachShader(shaderProgram, vertexShader)
	glAttachShader(shaderProgram, fragmentShader)
	glLinkProgram(shaderProgram)

	#glUseProgram(shaderProgram)
	glDeleteShader(vertexShader)
	glDeleteShader(fragmentShader)

	#positionAttribute = glGetAttribLocation(program, "position")
	#glEnableVertexAttribArray(positionAttribute)
	glVertexAttribPointer(0, 3, GL_FLOAT, false, 0, C_NULL)
	
	glEnableVertexAttribArray(0)
	#glVertexAttribPointer(positionAttribute, 2, GL_FLOAT, false, 3 * sizeof(GL_FLOAT), C_NULL)
	
	glBindBuffer(GL_ARRAY_BUFFER, 0)
	glBindVertexArray(0)

	while !GLFW.WindowShouldClose(window)

		# Poll for and process events
		GLFW.PollEvents()

		# Render here

		glClearColor(0.2, 0.3, 0.3, 1.0)
		glClear(GL_COLOR_BUFFER_BIT)
		
		glUseProgram(shaderProgram)
		glBindVertexArray(VAO)
		glDrawArrays(GL_TRIANGLES, 0, 3)
		glBindVertexArray(0)
		# Swap front and back buffers
		GLFW.SwapBuffers(window)
	end
	#glDeleteVertexArrays(1, VAO)
	#glDeleteBuffers(1, VBO)
	GLFW.Terminate()
end

main()
