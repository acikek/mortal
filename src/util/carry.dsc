mortal_carry:
    type: task
    definitions: target
    script:
        - define target_player <[target].flag[mortal.copy]>
        - if !<[target_player].is_online>:
            - narrate "<red>This player is offline."
            - stop

        - flag <player> mortal.carrying:<[target]>
        - flag <[target_player]> mortal.carried

        - mount <[target]>|<player>
        - adjust <[target_player]> spectate:<[target]>
        - narrate targets:<[target_player]> "<red>You are being carried by <&[emphasis]><player.name><red>!"

mortal_uncarry:
    type: task
    definitions: target
    script:
        #ratelimits player to make sure action doesnt happen twice
        - ratelimit <player> 1t
        #gets players
        - define target <player.flag[mortal.carrying]>
        - define target_player <player.flag[mortal.carrying].flag[mortal.copy]>

        #makes the player unspectate
        - adjust <[target_player]> spectate:<[target_player]>
        - mount cancel <[target]>
        - teleport <[target]> <player.location>

        #makes the npc sleep work because when sleeping npcs mounted then demounted it needs to stand
        - stand
        - sleep

        #bypass the player steps on block
        - flag <[target_player]> mortal.teleport
        - teleport <[target_player]> <[target].location>

        #unflags
        - flag <[target_player]> mortal.teleport:!
        - flag <[target_player]> mortal.carried:!
        - flag player mortal.carrying:!