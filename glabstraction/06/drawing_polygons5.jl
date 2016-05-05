using ModernGL, GeometryTypes, GLAbstraction, GLWindow

window = create_glcontext("Drawing polygons 5", resolution=(800, 600))

vao = glGenVertexArrays()
glBindVertexArray(vao)

positions = Point{2, Float32}[
	(-0.5, 0.5),
	(0.5, 0.5),
	(0.5, -0.5),
	(-0.5, -0.5)
]

colors = Vec3f0[
	(1, 0, 0),
	(0, 1, 0),
	(0, 0, 1),
	(1, 1, 1)
]

elements = Face{3, UInt32, -1}[(0,1,2), (2,3,0)]

vertex_source= vert"""
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

fragment_source = frag"""
# version 150

in vec3 Color;

out vec4 outColor;
void main()
{
    outColor = vec4(Color, 1.0);
}
"""

bufferdict = Dict(:position=>GLBuffer(positions),
		:color=>GLBuffer(colors),
		:indexes=>indexbuffer(elements))

ro = std_renderobject(bufferdict, LazyShader(vertex_source, fragment_source))

while !GLFW.WindowShouldClose(window)
	render(ro)
	GLFW.SwapBuffers(window)
	GLFW.PollEvents()
	if GLFW.GetKey(window, GLFW.KEY_ESCAPE) == GLFW.PRESS
		GLFW.SetWindowShouldClose(window, true)
	end
end

GLFW.DestroyWindow(window)
