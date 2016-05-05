using ModernGL, GeometryTypes, GLAbstraction, GLWindow

window = create_glcontext("Drawing polygons 4", resolution=(800, 600))

vao = Ref(GLuint(0))
glGenVertexArrays(1, vao)
glBindVertexArray(vao[])

vertices = Point{5, Float32}[
	(0, 0.5, 1, 0, 0),
	(0.5, -0.5, 0, 1, 0),
	(-0.5, -0.5, 0, 0, 1),
	(-0.5, -0.5, 1, 1, 1)
	]

elements = Vec{3, GLuint}[(0,1,2), (2,3,0)]

vbo = Ref(GLuint(0))
glGenBuffers(1, vbo)
glBindBuffer(GL_ARRAY_BUFFER, vbo[])
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

ebo = Ref(GLuint(0))
glGenBuffers(1, ebo)
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ebo[])
glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(elements), elements, GL_STATIC_DRAW)

vertex_source= """
# version 150
in vec2 position;
in vec3 color;

out vec3 Color;

void main()
{
	Color = color;
	gl_Position = vec4(position, 0.0, 1.0);
}
"""

fragment_source = """
# version 150

in vec3 Color;

out vec4 outColor;
void main()
{
    outColor = vec4(Color, 1.0);
}
"""

vertex_shader = glCreateShader(GL_VERTEX_SHADER)
glShaderSource(vertex_shader, vertex_source)
glCompileShader(vertex_shader)

status = Ref(GLint(0))
glGetShaderiv(vertex_shader, GL_COMPILE_STATUS, status)
if status[] != GL_TRUE
	buffer = Array(UInt8, 512)
	glGetShaderInfoLog(vertex_shader, 512, C_NULL, buffer)
	error(bytestring(buffer))
end

fragment_shader = glCreateShader(GL_FRAGMENT_SHADER)
glShaderSource(fragment_shader, fragment_source)
glCompileShader(fragment_shader)

status = Ref(GLint(0))
glGetShaderiv(fragment_shader, GL_COMPILE_STATUS, status)
if status[] != GL_TRUE
	buffer = Array(UInt8, 512)
	glGetShaderInfoLog(fragment_shader, 512, C_NULL, buffer)
	error(bytestring(buffer))
end

shader_program = glCreateProgram()
glAttachShader(shader_program, vertex_shader)
glAttachShader(shader_program, fragment_shader)
glBindFragDataLocation(shader_program, 0, "outColor")
glLinkProgram(shader_program)
glUseProgram(shader_program)

pos_attribute = glGetAttribLocation(shader_program, "position")
glVertexAttribPointer(pos_attribute, 2, GL_FLOAT, GL_FALSE, 5*sizeof(Float32), C_NULL)
glEnableVertexAttribArray(pos_attribute)

col_attribute = glGetAttribLocation(shader_program, "color")
glEnableVertexAttribArray(col_attribute)
glVertexAttribPointer(col_attribute, 3, GL_FLOAT, GL_FALSE, 5*sizeof(Float32), Ptr{Void}(2*sizeof(Float32)))

while !GLFW.WindowShouldClose(window)
	#glClearColor(0.2, 0.3, 0.3, 1.0)
	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, C_NULL)
	GLFW.SwapBuffers(window)
	GLFW.PollEvents()
	if GLFW.GetKey(window, GLFW.KEY_ESCAPE) == GLFW.PRESS
		GLFW.SetWindowShouldClose(window, true)
	end
end

GLFW.DestroyWindow(window)
