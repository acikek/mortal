mortal_grip:
  type: task
  definitions: target
  script:
  - define target_player <[target].flag[mortal.copy]>
  - if !<[target_player].is_online>:
    - narrate "<red>This player is offline."
    - stop
  - flag <player> mortal.gripping
  - flag <player> mortal.griplog
  - inject grutilbar defs:<[target_player]>|"Grip"|"Gripp"
  - flag <[target_player]> mortal.mortem
  - run mortal_create_grave def:<[target].location>|<[target_player]>
  - adjust <[target_player]> gamemode:survival
  - hurt <[target_player].health> <[target_player]>
  - flag <player> mortal.gripping:!
  - flag <[target_player]> mortal.dying:!
  - flag <[target_player]> mortal.griplog:!
  - remove <[target]>
  - bossbar remove <[id]>


mortal_grip_logout:
  type: world
  events:
    on player quits flagged:mortal.griplog:
    - inject mortal_find_dying_player
    - remove <[target]>
    - flag <player> mortal.mortem
    - flag <player> mortal.dying:!
    - run mortal_create_grave def:<player.location>|<player>
    - adjust <player> gamemode:survival
    - hurt <player.health>
    - flag player mortal.griplog:!
