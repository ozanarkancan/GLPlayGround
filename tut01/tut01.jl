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

	while !GLFW.WindowShouldClose(window)

		# Poll for and process events
		GLFW.PollEvents()

		# Render here

		glClearColor(0.2, 0.3, 0.3, 1.0)
		glClear(GL_COLOR_BUFFER_BIT)

		# Swap front and back buffers
		GLFW.SwapBuffers(window)
	end

	GLFW.Terminate()
end

main()
