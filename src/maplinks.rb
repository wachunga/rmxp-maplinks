#==============================================================================
# ** Maplinks
#------------------------------------------------------------------------------
# Wachunga
# Version 1.0
# 2006-10-29
# See https://github.com/wachunga/rmxp-maplinks for details
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# * SDK Log Script
#------------------------------------------------------------------------------
SDK.log('Maplinks', 'Wachunga', 1.0, '2006-10-29')

#------------------------------------------------------------------------------
# * Begin SDK Enabled Check
#------------------------------------------------------------------------------
if SDK.state('Maplinks') == true


class Game_Event < Game_Character
  
  alias wachunga_ml_game_event_init initialize
  def initialize(map_id, event)
    wachunga_ml_game_event_init(map_id, event)
    # check if event includes a maplink
    if @event.name.upcase.include?('<MAPLINK>')
      dir = nil
      if @event.y == $game_map.height-1
        dir = 2 unless @event.x == 0 or @event.x == $game_map.width-1
      elsif @event.x == 0
        dir = 4 unless @event.y == 0 or @event.y == $game_map.height-1
      elsif @event.x == $game_map.width-1
        dir = 6 unless @event.y == 0 or @event.y == $game_map.height-1
      elsif @event.y == 0
        dir = 8 unless @event.x == 0 or @event.x == $game_map.width-1
      end
      if dir != nil
        @list.each { |command|
          if command.code == 201
            # make sure new location isn't specified by variables
            if command.parameters[0] == 0
              $game_map.add_maplink(dir, command.parameters)
              break
            end
          end
        }
      end
    end
  end
  
end

#------------------------------------------------------------------------------

class Game_Map
  
  alias wachunga_ml_gm_setup setup
  def setup(map_id)
    @maplinks = {}
    wachunga_ml_gm_setup(map_id)
  end
  
  #----------------------------------------------------------------------------
  # * Maplink Addition
  #     dir        : direction of maplink to be added
  #     parameters : teleportation parameters (destination map id, x, y, etc.)
  #----------------------------------------------------------------------------
  def add_maplink(dir, parameters)
    @maplinks[dir] = parameters
  end

  #----------------------------------------------------------------------------
  # * Maplink Activation
  #     dir : direction of maplink to be activated
  #----------------------------------------------------------------------------
  def activate_maplink(dir)
    return if @maplinks[dir] == nil
    params = @maplinks[dir]
    # params[1] = map id
    # params[2] = x
    # params[3] = y
    width = load_data(sprintf("Data/Map%03d.rxdata", params[1])).width
    height = load_data(sprintf("Data/Map%03d.rxdata", params[1])).height
    # copy current x coordinate if north/south or y coordinate if east/west
    if (dir == 2 and params[3] == 0) or (dir == 8 and params[3] == height-1)
      params[2] = $game_player.x
    elsif (dir == 4 and params[2] == width-1) or (dir == 6 and params[2] == 0)
      params[3] = $game_player.y
    end
    # set up a dummy interpreter just for teleport
    interpreter = Interpreter.new
    interpreter.parameters = params
    interpreter.index = 0
    interpreter.command_201
  end

end

#------------------------------------------------------------------------------

class Interpreter
  attr_accessor :parameters
  attr_accessor :index
end

#------------------------------------------------------------------------------

class Game_Player

  alias wachunga_ml_game_player_cett check_event_trigger_touch
  def check_event_trigger_touch(x, y)
    check_maplinks(x,y)
    wachunga_ml_game_player_cett(x,y)
  end
  
  #----------------------------------------------------------------------------
  # * Maplink Checking
  #     x : x coordinate of map to check for a maplink
  #     y : y coordinate of map to check for a maplink
  #----------------------------------------------------------------------------
  def check_maplinks(x,y)
    if $game_map.valid?(x,y) then return end
    dir = nil
    if y == $game_map.height then dir = 2
    elsif x == -1 then dir = 4
    elsif x == $game_map.width then dir = 6
    elsif y == -1 then dir = 8
    end
    if dir != nil
      $game_map.activate_maplink(dir)
    end
  end

end

#------------------------------------------------------------------------------
# * End SDK Enable Test
#------------------------------------------------------------------------------
end

