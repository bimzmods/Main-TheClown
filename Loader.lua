local Games = {
    [1234567890] = "https://example.com/game1.lua",
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
