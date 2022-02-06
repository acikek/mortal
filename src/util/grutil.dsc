grutilbar:
    type: task
    definitions: target_player|text|text2
    script:
        - define id grip_<[target_player].name>
        - define title "<red><[text2]>ing <yellow><[target_player].name><green>..."
        - bossbar create <[id]> players:<player>|<[target_player]> color:red style:segmented_10 title:<[title]> progress:0.0
        - repeat 10 as:n:
            - wait 10t
            - if !<player.has_flag[mortal.gripping]>||!<player.has_flag[mortal.reviving]>:
                - define err "<[text]> stopped."
            - else if !<player.is_online> || !<[target_player].is_online>:
                - flag <player> mortal.gripping:!
                - flag <player> mortal.reviving:!
                - define err "Player went offline."
            - if <[err].exists>:
                - bossbar update <[id]> color:red title:<red><[err]>
                - wait 3s
                - bossbar remove <[id]>
                - stop
                - bossbar update <[id]> progress:<[n].div[10]>