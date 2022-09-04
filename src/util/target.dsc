mortal_find_dying_player:
  type: task
  debug: false
  script:
  # Find the first NPC within 2 blocks of the player's location
  - define target <player.location.find_npcs_within[2].first.if_null[null]>
  # Stop if the NPC wasn't found or doesn't have the proper flag
  - if <[target]> == null or not <[target].has_flag[mortal.copy]>:
    - stop
  # Define to <npc>
  - define __npc <[target]>

mortal_check_target_player:
  type: task
  script:
  - define target_player <npc.flag[mortal.copy]>
  - if !<[target_player].is_online>:
    - narrate "<&[error]>This player is offline."
    - stop