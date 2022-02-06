mortal_revive:
  type: task
  definitions: target
  script:
  - define target_player <[target].flag[mortal.copy]>
  - if !<[target_player].is_online>:
    - narrate "<red>This player is offline."
    - stop
  # Put player in "reviving" state to check for movement
  - flag <player> mortal.reviving
  - inject grutilbar defs:<[target_player]>|"Revive"|"Reviv"
  # Revive player
  - flag <[target_player]> mortal.dying:!
  - flag <player> mortal.reviving:!
  - flag <[target_player]> mortal.griplog:!
  - adjust <[target_player]> gamemode:survival
  - adjust <[target_player]> health:2
  # Remove copy NPC
  - remove <[target]>
  # Confirmation message via bossbar, then remove
  - bossbar update <[id]> title:<green>Success!
  - wait 3s
  - bossbar remove <[id]>