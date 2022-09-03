mortal_execute:
  type: task
  debug: true
  definitions: target
  script:
    - define target_player <[target].flag[mortal.copy]>
    - if !<[target_player].is_online>:
        - narrate "<&[error]>This player is offline."
        - stop
    - if <[target_player].has_flag[mortal.reviving]> || <[target_player].has_flag[mortal.carried]>:
        - narrate "<&[error]>This player already has an incoming action."
        - stop

    # Puts both players into an executing state
    - flag player mortal.executing
    - flag <[target_player]> mortal.execute

    # Create countdown bossbar
    - define id execute_<[target_player].name>
    - define title "<red>Executing <&[emphasis]><[target_player].name><green>..."
    - bossbar create <[id]> players:<player>|<[target_player]> color:red style:segmented_10 title:<[title]> progress:0.0

    # Countdown
    - repeat 10 as:n:
        - wait 5t
        - if !<player.has_flag[mortal.executing]>:
            - define err "Execution Stopped."
        - else if !<player.is_online> || !<[target_player].is_online>:
            - flag <player> mortal.executing:!
            - define err "Player went offline."
        - if <[err].exists>:
            - flag <[target_player]> mortal.execute:!
            - bossbar update <[id]> color:red title:<red><[err]>
            - wait 1.5s
            - bossbar remove <[id]>
            - stop
        - bossbar update <[id]> progress:<[n].div[10]>


    - bossbar remove <[id]>

    # Plays death effects
    - playeffect effect:redstone at:<[target].eye_location> special_data:1|#ff0000 quantity:100 offset:0.3,0.3,0.3
    - repeat 5:
        - playsound sound:block_grass_break pitch:0.2 <[target].eye_location>

    # Kills the player
    - kill <[target_player]>
    - adjust <[target_player]> gamemode:survival

    # Unflags all players
    - flag player mortal.executing:!
    - flag <[target_player]> mortal.execute:!
    - flag <[target_player]> mortal.dying:!

    - remove <[target]>