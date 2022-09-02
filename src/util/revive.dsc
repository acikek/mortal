mortal_revive:
  type: task
  definitions: target
  script:
  - inject mortal_check_target_player
  # Put player in "reviving" state to check for movement
  - flag <player> mortal.reviving
  # Create countdown bossbar
  - define id revive_<[target_player].name>
  - define title "<green>Reviving <&[emphasis]><[target_player].name><green>..."
  - bossbar create <[id]> players:<player>|<[target_player]> color:green style:segmented_10 title:<[title]> progress:0.0
  # Countdown with 10s
  - repeat 10 as:n:
    - wait 1s
    # Stop if: player moves (no longer has reviving flag)
    - if not <player.has_flag[mortal.reviving]> or <[target_player].has_flag[mortal.carried]>:
      - define err "Reviving stopped."
    # or one of them goes offline
    - else if not <player.is_online> or not <[target_player].is_online>:
      - flag <player> mortal.reviving:!
      - define err "Player went offline."
    # If error, update bossbar and stop
    - if <[err].exists>:
      - bossbar update <[id]> color:red title:<red><[err]>
      - wait 3s
      - bossbar remove <[id]>
      - stop
    # Progress bossbar
    - bossbar update <[id]> progress:<[n].div[10]>
  # Revive player
  - flag <[target_player]> mortal.dying:!
  - flag <player> mortal.reviving:!
  - adjust <[target_player]> gamemode:survival
  - adjust <[target_player]> health:2
  # Remove copy NPC
  - remove <[target]>
  # Confirmation message via bossbar, then remove
  - bossbar update <[id]> title:<green>Success!
  - wait 3s
  - bossbar remove <[id]>