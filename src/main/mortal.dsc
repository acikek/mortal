mortal_true_death:
  type: task
  script:
  - inject mortal_find_dying_player
  # Add grave
  - run mortal_create_grave def:<npc.location>
  # Kill player
  - adjust <player> gamemode:survival
  - kill
  - flag <player> mortal.dying:!
  # Remove NPC
  - remove <npc>

mortal:
  type: world
  events:
    on player dies flagged:!mortal.dying|!mortal.mortem:
    - determine passively cancelled
    # Put the player in spectator mode - can still look around but not present
    - adjust <player> gamemode:spectator
    # Create an NPC of the player
    - create player <player.name> save:copy
    - define __npc <entry[copy].created_npc>
    - adjust <npc> skin_blob:<player.skin_blob>
    # Spawn after skin loaded
    - spawn <npc> <player.location>
    # Adjust the NPC to not be affected by gravity
    - adjust <npc> gravity:false
    - animate <npc> sleep
    # Flag the player in the "dying" state
    - flag <player> mortal.dying
    - flag <npc> mortal.copy:<player>
    # Narrate eath message
    - narrate "<&[negative]>You're dying! Wait for someone to revive you, or use <&[emphasis]>/mortem <&[negative]>to end your life."
    on player dies flagged:mortal.mortem:
    - determine passively no_message
    - customevent id:mortal_mortem save:result
    # Don't un-flag player if event determines 'keep_flag'
    - if keep_flag not in <entry[result].determination_list>:
      - flag <player> mortal.mortem:!