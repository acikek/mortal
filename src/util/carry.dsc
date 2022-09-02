mortal_carry:
  type: task
  definitions: target
  script:
  - inject mortal_check_target_player

  - flag <player> mortal.carrying:<[target]>
  - flag <[target_player]> mortal.carried

  - mount <[target]>|<player>
  - adjust <[target_player]> spectate:<[target]>
  - narrate targets:<[target_player]> "<&[base]>You are being carried by <&[emphasis]><player.name><&[base]>!"

mortal_uncarry:
  type: task
  definitions: target
  script:
  # Ratelimit player to make sure this doesn't happen twice
  - ratelimit <player> 1t

  - define target <player.flag[mortal.carrying]>
  - define target_player <player.flag[mortal.carrying].flag[mortal.copy]>

  # Un-spectate and un-mount the players
  - adjust <[target_player]> spectate:<[target_player]>
  - mount cancel <[target]>
  - teleport <[target]> <player.location>

  #| When sleeping NPCs are mounted and then un-mounted, they need to stand.
  #| This forces the NPC to stand and sleep again.
  - stand npc:<[target]>
  - sleep npc:<[target]>

  # To make sure the player the "player steps on block" event (actions.dsc), put them in a temporary "teleporting" state.
  - flag <[target_player]> mortal.teleport
  - teleport <[target_player]> <[target].location>
  - flag <[target_player]> mortal.teleport:!

  - flag <[target_player]> mortal.carried:!
  - flag player mortal.carrying:!