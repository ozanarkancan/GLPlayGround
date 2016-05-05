using ModernGL, GeometryTypes, GLAbstraction, GLWindow, Images, FileIO, Reactive

kitten = load("../images/kitten.png")
puppy = load("../images/puppy.png")


window = create_glcontext("Transformations 1", resolution=(600, 600))

vao = glGenVertexArrays()
glBindVertexArray(vao)

positions = Point{2, Float32}[
	(-0.5, 0.5),
	(0.5, 0.5),
	(0.5, -0.5),
	(-0.5, -0.5)
]

texcoords = Vec2f0[
	(0,0),
	(1,0),
	(1,1),
	(0,1)
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
in vec2 texcoord;

out vec3 Color;
out vec2 Texcoord;

uniform mat4 trans;

void main()
{
	Color = color;
	Texcoord = texcoord;
	gl_Position = trans * vec4(position, 0.0, 1.0);
}
"""

fragment_source = frag"""

# version 150

in vec3 Color;
in vec2 Texcoord;

out vec4 outColor;

uniform sampler2D texKitten;
uniform sampler2D texPuppy;

void main()
{
    vec4 colKitten = texture(texKitten, Texcoord);
    vec4 colPuppy  = texture(texPuppy,  Texcoord);
    outColor = mix(colKitten, colPuppy, 0.5);
}
"""

trans = Signal(rotate(0f0, Vec((0, 0, 1f0))))

bufferdict = Dict(:position=>GLBuffer(positions),
		:texcoord=>GLBuffer(texcoords),
		:texKitten=>Texture(data(kitten)),
		:texPuppy=>Texture(data(puppy)),
		:trans=>trans,
		:indexes=>indexbuffer(elements))

ro = std_renderobject(bufferdict, LazyShader(vertex_source, fragment_source))

glClearColor(0.2,0.2,0.2,1)
while !GLFW.WindowShouldClose(window)
	push!(trans, rotationmatrix_z(time()*deg2rad(180)))
	Reactive.run_till_now()
	glClear(GL_COLOR_BUFFER_BIT)
	render(ro)
	GLFW.SwapBuffers(window)
	GLFW.PollEvents()
	if GLFW.GetKey(window, GLFW.KEY_ESCAPE) == GLFW.PRESS
		GLFW.SetWindowShouldClose(window, true)
	end
end

GLFW.DestroyWindow(window)
