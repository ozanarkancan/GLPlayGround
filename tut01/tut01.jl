using GLFW
using ModernGL

GLFW.Init()
GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 3)
GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
GLFW.WindowHint(GLFW.RESIZABLE, false)

window = GLFW.CreateWindow(800, 600, "Tutorial 1")
GLFW.MakeContextCurrent(window)
glViewport(0, 0, 800, 600);

while !GLFW.WindowShouldClose(window)

	# Render here
	
	# Poll for and process events
	GLFW.PollEvents()

	# Swap front and back buffers
	GLFW.SwapBuffers(window)
end

GLFW.Terminate()
