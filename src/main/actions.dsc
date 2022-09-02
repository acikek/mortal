mortal_actions:
  type: world
  debug: false
  events:
    after player right clicks block flagged:!mortal.reviving:
    # Block looting/reviving if the player is the one dying
    - stop if:<player.has_flag[mortal.dying].or[<player.has_flag[mortal.carrying]>]>
    - inject mortal_find_dying_player
    # Revive if sneaking
    - if <player.is_sneaking>:
      - inject mortal_revive
    # Loot otherwise
    - else:
      - inventory open d:<[target].flag[mortal.copy].inventory>
    after player right clicks block location_flagged:mortal.grave:
    - inventory open d:<context.location.flag[mortal.grave]>
    - flag <player> mortal.looting:<context.location>
    after player closes inventory flagged:mortal.looting:
    - if <context.inventory.is_empty>:
      - modifyblock <player.flag[mortal.looting]> air
      - flag <player> mortal.looting:!
    on player breaks block location_flagged:mortal.grave:
    - determine passively cancelled
    - narrate "<&[error]>Loot this grave completely to remove it."
    after player left clicks block flagged:!mortal.carrying:
      - inject mortal_find_dying_player
      - if <player.is_sneaking>:
        - inject mortal_carry
    after player right clicks npc flagged:mortal.carrying:
    - if <player.is_sneaking>:
      - inject mortal_uncarry

    on player damaged flagged:mortal.carrying:
    - inject mortal_uncarry

mortal_cancel_state:
  type: world
  debug: false
  events:
    on player steps on block flagged:mortal.dying:
    - stop if:<player.has_flag[mortal.teleport]>
    - determine cancelled
    on player spectates entity flagged:mortal.dying:
    - determine cancelled
    on player steps on block flagged:mortal.reviving:
    - flag <player> mortal.reviving:!
