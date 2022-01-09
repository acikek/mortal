mortal:
  type: world
  events:
    on player dies flagged:!mortal.dying|!mortal.mortem:
    - determine passively cancelled
    # Put the player in spectator mode - can still look around but not present
    - adjust <player> gamemode:spectator
    # Create an NPC of the player
    - create player <player.name> <player.location> save:copy
    # Adjust the NPC to not be affected by gravity
    - adjust <entry[copy].created_npc> gravity:false
    - animate <entry[copy].created_npc> sleep
    # Flag the player in the "dying" state
    - flag <player> mortal.dying
    - flag <entry[copy].created_npc> mortal.copy:<player>
    # Narrate eath message
    - narrate "<red>You're dying! Wait for someone to revive you, or use <yellow>/mortem <red>to end your life."
    on player dies flagged:mortal.mortem:
    - determine passively no_message
    - announce "<player.name> met their own blade"
    - flag <player> mortal.mortem:!