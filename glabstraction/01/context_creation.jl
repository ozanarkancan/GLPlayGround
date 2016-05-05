import GLFW
using ModernGL

GLFW.WindowHint(GLFW.RESIZABLE, GL_FALSE)
window = GLFW.CreateWindow(800, 600, "Context creation example")

GLFW.MakeContextCurrent(window)

GLFW.SetInputMode(window, GLFW.STICKY_KEYS, GL_TRUE)

while !GLFW.WindowShouldClose(window)
	GLFW.SwapBuffers(window)
	GLFW.PollEvents()
	if GLFW.GetKey(window, GLFW.KEY_ESCAPE) == GLFW.PRESS
		GLFW.SetWindowShouldClose(window, true)
	end
end

GLFW.DestroyWindow(window)
