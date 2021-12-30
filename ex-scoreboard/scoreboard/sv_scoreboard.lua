local QBCore = exports['qb-core']:GetCoreObject() 

local ST = ST or {}
ST.Scoreboard = {}
ST._Scoreboard = {}
ST._Scoreboard.PlayersS = {}
ST._Scoreboard.RecentS = {}


ADMIN = 'steam:adminshex'..'steam:adminshex1'..'steam:adminshex2'..'steam:adminshex3' --add many as u want just follow the format



T1 = 'steam:priohex'..'steam:priohex1'..'steam:priohex2'..'steam:priohex3'   --thats for priority holders


SS = 'steam:staffhex'..'steam:staffhex1' --thats for staff

RegisterServerEvent('st-scoreboard:AddPlayer')
AddEventHandler("st-scoreboard:AddPlayer", function()
    --print("add player server" )
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local data = { src = source, steamid = stid, comid = scomid, name = ply }

    TriggerClientEvent("st-scoreboard:AddPlayer", -1, data )
    ST.Scoreboard.AddAllPlayers()
end)

RegisterServerEvent('st-scoreboard:GiveMePlayers')
AddEventHandler("st-scoreboard:GiveMePlayers", function()
    ST.Scoreboard.AddAllPlayers()
end)


function ST.Scoreboard.AddAllPlayers(self)
    local xPlayers   = QBCore.Functions.GetPlayers()

    for i=1, #xPlayers, 1 do
        local identifiers, steamIdentifier = GetPlayerIdentifiers(xPlayers[i])
        for _, v in pairs(identifiers) do
            if string.find(v, "steam") then
                steamIdentifier = v
                break
            end
        end

        ----ADMINS---
        if string.find(ADMIN,steamIdentifier)then
            stid = "~r~".. string.upper(steamIdentifier)
        ----Tier 1---
        elseif string.find(T1,steamIdentifier)then
            stid = "~y~".. string.upper(steamIdentifier)
       elseif string.find(SS,steamIdentifier)then
            stid = "~p~".. string.upper(steamIdentifier)
        ---Normal--
        else
            stid =  string.upper(steamIdentifier)
        end
        
        local ply = GetPlayerName(xPlayers[i])
        local scomid = steamIdentifier:gsub("steam:", "")
        local ping = GetPlayerPing(xPlayers[i]); 
        local data = { src = xPlayers[i], steamid = stid, comid = scomid, name = ply, pong = ping }
        TriggerClientEvent("st-scoreboard:AddAllPlayers", source, data)
    end
end

function ST.Scoreboard.AddPlayerS(self, data)
    ST._Scoreboard.PlayersS[data.src] = data
end

AddEventHandler("playerDropped", function()
	local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    local stid = HexIdToSteamId(steamIdentifier)
    local ply = GetPlayerName(source)
    local scomid = steamIdentifier:gsub("steam:", "")
    local plyid = source
    local data = { src = source, steamid = stid, comid = scomid, name = ply }

    TriggerClientEvent("st-scoreboard:RemovePlayer", -1, data )
    Wait(600000)
    TriggerClientEvent("st-scoreboard:RemoveRecent", -1, plyid)
end)



function HexIdToSteamId(hexId)
    local cid = math.floor(tonumber(string.sub(hexId, 7), 16))
	local steam64 = math.floor(tonumber(string.sub( cid, 2)))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	local sid = "STEAM_0:"..a..":"..(a == 1 and b -1 or b)
    return sid
end
