using ModernGL, GeometryTypes, GLAbstraction, GLWindow

window = create_glcontext("Drawing polygons 2", resolution=(800, 600))

vao = Ref(GLuint(0))
glGenVertexArrays(1, vao)
glBindVertexArray(vao[])

vertices = Point2f0[(0, 0.5), (0.5, -0.5), (-0.5, -0.5)]

vbo = Ref(GLuint(0))
glGenBuffers(1, vbo)
glBindBuffer(GL_ARRAY_BUFFER, vbo[])
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW)

vertex_source= """
# version 150
in vec2 position;

void main()
{
	gl_Position = vec4(position, 0.0, 1.0);
}
"""

fragment_source = """
# version 150

uniform vec3 triangleColor;

out vec4 outColor;
void main()
{
    outColor = vec4(triangleColor, 1.0);
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
glVertexAttribPointer(pos_attribute, length(eltype(vertices)), GL_FLOAT, GL_FALSE, 0, C_NULL)
glEnableVertexAttribArray(pos_attribute)

uni_color = glGetUniformLocation(shader_program, "triangleColor")

while !GLFW.WindowShouldClose(window)
	r = (sin(4*time()) + 1) / 2
	glUniform3f(uni_color, Float32(r), 0.0f0, 0.0f0)
	glDrawArrays(GL_TRIANGLES, 0, length(vertices))
	GLFW.SwapBuffers(window)
	GLFW.PollEvents()
	if GLFW.GetKey(window, GLFW.KEY_ESCAPE) == GLFW.PRESS
		GLFW.SetWindowShouldClose(window, true)
	end
end

GLFW.DestroyWindow(window)
