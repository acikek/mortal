mortal_create_grave:
  type: task
  definitions: location
  script:
  - if !<player.inventory.is_empty>:
    # Place skull with random rotation
    - modifyblock <[location]> player_head[direction=<material[skeleton_skull].valid_directions.random>]
    - adjust <[location]> skull_skin:<player.skull_skin>
    # Generate and set grave inventory
    - define inv "<inventory[generic[size=54;title=<player.name>'s Grave]]>"
    - inventory copy d:<[inv]> o:<player.inventory>
    - flag <[location]> mortal.grave:<[inv]>
    # Clear player's inventory
    - inventory clear