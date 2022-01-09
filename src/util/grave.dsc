mortal_grave:
  type: inventory
  inventory: chest
  slots:
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []

mortal_create_grave:
  type: task
  definitions: location
  script:
  - if !<player.inventory.is_empty>:
    # Place skull with random rotation
    - modifyblock <[location]> skeleton_skull[direction=<material[skeleton_skull].valid_directions.random>]
    # Generate and set grave inventory
    - define inv <inventory[mortal_grave]>
    - adjust <[inv]> "title:<player.name>'s Grave"
    - inventory copy d:<[inv]> o:<player.inventory>
    - flag <[location]> mortal.grave:<[inv]>
    # Clear player's inventory
    - inventory clear