function add_gnomes(event)
    --give the player some gnomes to start things off with
    local player = game.players[event.player_index]
    if not player.get_main_inventory() then return end
    local inventory = player.get_main_inventory()
    player.insert{name="transport-belt", count=1}
end

script.on_event(defines.events.on_player_created, add_gnomes)
script.on_event(defines.events.on_cutscene_cancelled, addgnomes)