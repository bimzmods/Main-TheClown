local Games = {
    [7633926880] = "https://raw.githubusercontent.com/bimzmods/Main-TheClown/refs/heads/main/Games/Bloxstrike_BZ.lua",
    [9876543210] = "https://example.com/game2.lua",
}

local link = Games[game.PlaceId]

if link then
    local ok, err = pcall(function()
        loadstring(game:HttpGet(link))()
    end)
    if not ok then
        warn("Gagal load script: " .. tostring(err))
    end
else
    warn("Game ini belum didukung. PlaceId: " .. game.PlaceId)
end
