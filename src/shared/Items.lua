-- Catálogo original do Mystery Machine
local items = {
    {"cup", "Copo Cósmico", "Comum", 200, 8},
    {"ball", "Bola Lunar", "Comum", 160, 9},
    {"toycar", "Carrinho Turbo", "Comum", 140, 10},
    {"plush", "Ursinho Solar", "Comum", 120, 12},
    {"headphones", "Fone Neon", "Incomum", 95, 20},
    {"watch", "Relógio Pixel", "Incomum", 75, 24},
    {"controller", "Controle Prisma", "Incomum", 60, 27},
    {"phone", "Celular Holo", "Incomum", 45, 33},
    {"drone", "Mini Drone", "Raro", 32, 50},
    {"console", "Console Pocket", "Raro", 24, 65},
    {"robot", "Robô BIP", "Raro", 18, 80},
    {"skate", "Patinete Turbo", "Raro", 12, 100},
    {"rocket", "Mini Foguete", "Épico", 8, 140},
    {"diamond", "Diamante Azul", "Épico", 5, 190},
    {"crown", "Coroa Antiga", "Épico", 3, 260},
    {"dragon", "Dragão Cristal", "Lendário", 1.5, 420},
    {"cube", "Cubo do Vazio", "Lendário", 0.8, 650},
    {"relic", "Relíquia Solar", "Lendário", 0.4, 900},
    {"star", "Estrela Galáctica", "Secreto", 0.2, 1600},
    {"artifact", "Artefato Ômega", "Secreto", 0.1, 3000}
}
local result, byId, weight = {}, {}, 0
for _, row in ipairs(items) do
    local item = {id=row[1], name=row[2], rarity=row[3], weight=row[4], value=row[5]}
    table.insert(result, item)
    byId[item.id] = item
    weight += item.weight
end
local rng = Random.new()
return {
    all=result, byId=byId, totalWeight=weight,
    roll=function()
        local chosen = rng:NextNumber() * weight
        local cumulative = 0
        for _, item in ipairs(result) do
            cumulative += item.weight
            if chosen < cumulative then return item end
        end
        return result[#result]
    end
}
