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
  - define id rev_<[target_player].name>
  - define title "<green>Reviving <yellow><[target_player].name><green>..."
  - bossbar create <[id]> players:<player>|<[target_player]> color:green style:segmented_10 title:<[title]> progress:0.0
  - teleport <player> <[target].eye_location.relative[-0.5,0,0.5]>
  - animate <player> animation:sit
  - repeat 10 as:n:
    - wait 20t
    - if !<player.has_flag[mortal.reviving]>:
      - animate <player> animation:ARM_SWING
      - define err "Revive stopped."
      - animate <player> animation:stop_sitting
      - run mortal_bossbar_update def:<&c>|<[id]>|<[err]>
      - stop
    - bossbar update <[id]> progress:<[n].div[10]>
    - run mortal_bossbar_player_online_check def:<[target_player]>
  # Revive player
  - flag <[target_player]> mortal.dying:!
  - flag <player> mortal.reviving:!
  - animate <player> animation:stop_sitting
  - playeffect effect:RED_DUST at:<[target_player].location.points_around_y[radius=1;points=50]> special_data:1.2|lime quantity:100 offset:0,1,0
  - adjust <[target_player]> gamemode:survival
  - adjust <[target_player]> health:2
  # Remove copy NPC
  - remove <[target]>
  # Confirmation message via bossbar, then remove
  - bossbar update <[id]> title:<green>Success!
  - wait 3s
  - bossbar remove <[id]>