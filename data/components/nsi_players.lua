local function NSIPlayersPostInit(inst)
    print("[NSIPlayersPostInit]")
    self.players = {}

    local old2 = self.OnSave
    function self:OnSave()
        local data = {}
        data.players = self.players
        data.olddata = old2(self)
        return data
    end

    local old3 = self.OnLoad
    function self:OnLoad(data, newents)
        if data and data.players then
            self.players = data.players
        end
        if data and data.olddata then
            old3(self, data.olddata, newents)
        end
    end

    return inst
end

AddComponentPostInit("nsi_players", NSIPlayersPostInit)