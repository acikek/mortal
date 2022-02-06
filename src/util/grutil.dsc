mortal_bossbar_player_online_check:
    type: task
    definitions: target_player
    script:
        - if !<player.is_online> || !<[target_player].is_online>:
            - flag <player> mortal.gripping:!
            - flag <player> mortal.reviving:!
            - define err "Player went offline."

mortal_bossbar_update:
    type: task
    definitions: color|id|err
    script:
        - if <[err].exists>:
            - bossbar update <[id]> color:<[color]> title:<[color]><[err]>
            - wait 3s
            - bossbar remove <[id]>
            - stop