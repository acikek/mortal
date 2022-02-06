mortal_grip:
  type: task
  definitions: target
  script:
  - define target_player <[target].flag[mortal.copy]>
  - if !<[target_player].is_online>:
    - narrate "<red>This player is offline."
    - stop

  - flag <player> mortal.gripping
  - define id grip_<[target_player].name>
  - define title "<red>Gripping <yellow><[target_player].name><green>..."
  - bossbar create <[id]> players:<player>|<[target_player]> color:red style:segmented_10 title:<[title]> progress:0.0
  - repeat 10 as:n:
    - wait 10t
    - if !<player.has_flag[mortal.gripping]>:
      - define err "Grip stopped."
    - else if !<player.is_online> || !<[target_player].is_online>:
      - flag <player> mortal.gripping:!
      - define err "Player went offline."
    - if <[err].exists>:
      - bossbar update <[id]> color:red title:<red><[err]>
      - wait 3s
      - bossbar remove <[id]>
      - stop
    - bossbar update <[id]> progress:<[n].div[10]>
  - flag <[target_player]> mortal.mortem
  - run mortal_create_grave def:<[target].location>|<[target_player]>
  - adjust <[target_player]> gamemode:survival
  - hurt <[target_player].health> <[target_player]>
  - flag <player> mortal.gripping:!
  - flag <[target_player]> mortal.dying:!
  - flag <[target_player]> griplog:!
  - remove <[target]>
  - bossbar remove <[id]>


mortal_grip_log:
  type: world
  events:
    on player quits flagged:griplog:
    - inject mortal_find_dying_player
    - remove <[target]>
    - flag <player> mortal.mortem
    - flag <player> mortal.dying:!
    - run mortal_create_grave def:<player.location>|<player>
    - adjust <player> gamemode:survival
    - hurt <player.health>
    - flag player griplog:!
