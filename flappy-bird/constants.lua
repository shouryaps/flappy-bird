WINDOW_WIDTH = 288
WINDOW_HEIGHT = 512

VIRTUAL_WIDTH = 288
VIRTUAL_HEIGHT = 512

-- game states
GAME_STATE_START = 1
GAME_STATE_PLAY = 2
GAME_STATE_PAUSE = 3
GAME_STATE_DONE = 4

-- background
DAY_BACKGROUND_PATH = "resources/sprites/background-day.png"
NIGHT_BACKGROUND_PATH = "resources/sprites/background-night.png"
BACKGROUND_SCROLL_SPEED = 10
BACKGROUND_LOOP_POINT = 556 - VIRTUAL_WIDTH -- 556 is width of background image here

-- base
BASE_PATH = "resources/sprites/base.png"
BASE_HEIGHT = 112
BASE_SCROLL_SPEED = 60
BASE_LOOP_POINT = 336 - VIRTUAL_WIDTH -- 336 is the width of base image

-- pipe spawning
SPAWN_PIPE_SECONDS = 3
PIPE_MIN_HEIGHT = 200
PIPE_MAX_HEIGHT = 280
PIPE_WIDTH = 52

-- constants for orientation
TOP = 1
BOTTOM = 2
