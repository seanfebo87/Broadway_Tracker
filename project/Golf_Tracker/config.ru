require './config/environment'

use Rack::MethodOverride
use PostController
use UserController
run ApplicationController
