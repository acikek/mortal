mortal_create_grave:
  type: task
  definitions: loc
  script:
  - stop if:<player.inventory.is_empty>
  # Place skull with random rotation
  - modifyblock <[loc]> player_head[direction=<material[skeleton_skull].valid_directions.random>]
  - adjust <[loc]> skull_skin:<player.skull_skin>
  # Generate and set grave inventory
  - define inv "<inventory[generic[size=54;title=<player.name>'s Grave]]>"
  - inventory copy d:<[inv]> o:<player.inventory>
  - flag <[loc]> mortal.grave:<[inv]>
  # Clear player's inventory
  - inventory clear