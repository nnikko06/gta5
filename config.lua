--[[
    NATURAL LIFE - RP · nl_basic_drugs
    Toda la configuración del sistema de drogas está aquí.
    Coordenadas: vec3(x, y, z)  ·  Con orientación (NPCs): vec4(x, y, z, heading)
    Tiempos en milisegundos (ms) salvo que se indique "segundos".
]]

Config = {}

-- Tipo de dinero que se paga/cobra en las ventas: 'cash' (efectivo) o 'bank'
Config.MoneyType = 'cash'

-- Distancia a la que aparecen/desaparecen los NPCs y las plantas (metros)
Config.RenderDistance = 60.0

-- Tiempo (segundos) que un NPC recuerda que ya te ha comprado/rechazado
Config.PedMemory = 600

-- Gancho preparado para la policía. NO está implementado todavía:
-- cuando exista, server/main.lua -> Drugs.onIllegalActivity() recibirá estos avisos.
Config.Police = {
    enabled = false,
}

--------------------------------------------------------------------------------
-- MARIHUANA (legal)
--------------------------------------------------------------------------------
Config.Weed = {
    enabled = true,

    items = {
        seed = 'semilla_marihuana',
        product = 'marihuana',
        tool = 'pala_jardin', -- herramienta necesaria para plantar (no se gasta)
    },
    requireTool = true, -- false = se puede plantar sin herramienta

    -- Tiendas (Grow Shop). Se abren acercándose al vendedor y pulsando E.
    -- Precios PROVISIONALES: la economía se ajustará más adelante.
    shops = {
        {
            label = 'Grow Shop',
            subtitle = 'Smoke on the Water · Playa de Vespucci',
            ped = { model = 'a_m_y_hipster_01', coords = vec4(-1170.8, -1570.6, 4.66, 124.0), scenario = 'WORLD_HUMAN_STAND_IMPATIENT' },
            blip = { enabled = true, sprite = 140, color = 27, scale = 0.8, label = 'Grow Shop' },
            items = {
                {
                    name = 'semilla_marihuana', price = 100,
                    description = 'Semilla lista para plantar.',
                    use = 'Úsala desde el inventario dentro de la zona de cultivo para plantar.',
                },
                {
                    name = 'pala_jardin', price = 250,
                    description = 'Herramienta de jardín. No se gasta.',
                    use = 'Necesaria para poder plantar. Llévala encima.',
                },
            },
            -- Sección "Información" de la tienda (textos cortos)
            info = {
                what = 'Cultivar marihuana legal para venderla y ganar dinero.',
                need = { 'Pala de jardín (se compra aquí, no se gasta)', 'Semillas de marihuana', 'Ir a la zona de cultivo de Grapeseed (marcada en el mapa)' },
                steps = {
                    'Compra una pala y semillas aquí.',
                    'Ve a la zona de cultivo de Grapeseed.',
                    'Usa una semilla desde el inventario para plantarla.',
                    'Espera unos 5 minutos y recoge la planta.',
                },
                result = 'Obtienes de 1 a 5 bolsas de marihuana. Véndelas a los compradores o a la gente de la calle.',
            },
        },
    },
    shopMaxAmount = 50,     -- máximo de unidades por compra
    shopDistance = 3.0,     -- distancia máxima al vendedor

    -- Compradores NPC fijos: se les vende pulsando E. Todo validado en el servidor.
    buyers = {
        {
            label = 'Comprador del puerto',
            ped = { model = 's_m_m_dockwork_01', coords = vec4(-1045.3, -1397.5, 5.43, 75.0), scenario = 'WORLD_HUMAN_SMOKING' },
            blip = { enabled = false, sprite = 500, color = 27, scale = 0.7, label = 'Comprador' },
            cooldown = 60,        -- segundos entre ventas del mismo jugador a este comprador
            products = {
                { item = 'marihuana', price = 40, min = 1, max = 20 }, -- precio por unidad y cantidad por venta
            },
        },
    },
    buyerDistance = 3.0,

    -- Zonas donde está permitido plantar
    plantZones = {
        {
            label = 'Plantación de Grapeseed',
            coords = vec3(2222.0, 5577.0, 53.8),
            radius = 30.0,
            blip = { enabled = true, color = 2, alpha = 90, sprite = 496, scale = 0.8, label = 'Zona de cultivo' },
        },
        -- Ejemplo de segunda zona:
        -- { label = 'Otra zona', coords = vec3(0.0, 0.0, 0.0), radius = 25.0, blip = { enabled = false } },
    },

    growTime = 300,                   -- segundos hasta que la planta está lista
    harvestAmount = { min = 1, max = 5 },
    maxPlantsPerPlayer = 5,
    minDistanceBetweenPlants = 1.5,   -- metros
    onlyOwnerCanHarvest = true,       -- false = cualquiera puede recoger plantas ajenas
    interactDistance = 2.0,

    plantTime = 5000,
    harvestTime = 5000,
    plantAnim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
    harvestAnim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },

    -- Modelo según el crecimiento (de 0 a 1). Se usa el último cuyo "progress" se haya alcanzado.
    plantStages = {
        { progress = 0.0, model = 'bkr_prop_weed_01_small_01b' },
        { progress = 0.5, model = 'bkr_prop_weed_med_01b' },
        { progress = 1.0, model = 'bkr_prop_weed_lrg_01b' },
    },

    -- Venta a NPCs de la calle (precio bajo)
    streetSale = {
        enabled = true,
        minPrice = 20,        -- precio por unidad
        maxPrice = 50,
        maxAmount = 3,        -- unidades máximas por venta
        cooldown = 15,        -- segundos entre ventas
        refuseChance = 15,    -- % de que el NPC rechace
        maxDistance = 3.0,
    },

    -- Venta entre jugadores
    playerSale = {
        enabled = true,
        maxDistance = 3.0,
        maxAmount = 100,      -- unidades máximas por oferta
        maxPrice = 100000,    -- precio total máximo por oferta
        timeout = 30,         -- segundos que tiene el comprador para aceptar
        cooldown = 5,         -- segundos entre ofertas del mismo vendedor
    },
}

--------------------------------------------------------------------------------
-- OPIO (ilegal) — mecánica ficticia de juego
--------------------------------------------------------------------------------
Config.Opium = {
    enabled = true,

    items = {
        raw = 'recurso_opio',
        product = 'opio',
    },

    -- Puntos calientes de recolección (dentro de la zona se pulsa la tecla)
    gatherZones = {
        {
            label = 'Great Chaparral',
            coords = vec3(-110.0, 1910.0, 197.0),
            radius = 40.0,
            blip = { enabled = false, color = 1, alpha = 90, sprite = 469, scale = 0.8, label = 'Punto caliente' }, -- NATURAL LIFE: ilegal, sin icono
        },
    },
    gather = {
        key = 'E',                    -- tecla para recolectar dentro de la zona
        time = 8000,
        cooldown = 10,                -- segundos
        amount = { min = 1, max = 3 },
        anim = { dict = 'amb@world_human_gardener_plant@male@base', clip = 'base' },
    },

    -- Puntos de procesamiento
    process = {
        points = {
            {
                label = 'Procesar opio',
                coords = vec3(2433.5, 4968.9, 42.3),
                radius = 1.5,
                blip = { enabled = false, sprite = 499, color = 1, scale = 0.8, label = 'Procesado' },
            },
        },
        time = 15000,
        cooldown = 20,                -- segundos
        input = 5,                    -- recurso_opio necesario
        output = 2,                   -- opio que se obtiene
        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
    },

    -- Isla: venta en grandes cantidades
    island = {
        enabled = true,
        label = 'Comprador de la isla',
        ped = { model = 'g_m_m_armboss_01', coords = vec4(4494.9, -4525.1, 4.4, 20.0), scenario = 'WORLD_HUMAN_SMOKING' },
        blip = { enabled = false, sprite = 480, color = 1, scale = 0.9, label = 'Isla (venta de opio)' }, -- NATURAL LIFE: ilegal, sin icono
        maxDistance = 3.0,
        minAmount = 20,
        maxAmount = 200,
        pricePerUnit = { min = 180, max = 220 },
        cooldown = 60,                -- segundos
        loadCayoPerico = true,        -- carga el mapa de Cayo Perico al acercarse
        cayoCenter = vec3(4840.0, -5174.0, 2.0),
    },

    -- Venta a NPCs de la calle (escala menor)
    streetSale = {
        enabled = true,
        minPrice = 80,
        maxPrice = 120,
        maxAmount = 3,
        cooldown = 20,
        refuseChance = 30,
        maxDistance = 3.0,
    },
}

--------------------------------------------------------------------------------
-- TEXTOS
--------------------------------------------------------------------------------
Config.Text = {
    wait = 'Espera %d segundos',
    cant_carry = 'No puedes cargar más',
    not_enough_money = 'No tienes suficiente dinero',
    too_far = 'Estás demasiado lejos',
    in_vehicle = 'No puedes hacerlo dentro de un vehículo',
    invalid_amount = 'Cantidad no válida',

    shop_open = 'Comprar',
    shop_bought = 'Has comprado %dx %s por %d €',

    need_tool = 'Necesitas una %s para plantar',
    not_in_zone = 'Aquí no se puede plantar',
    too_many_plants = 'Ya tienes el máximo de plantas (%d)',
    too_close = 'Demasiado cerca de otra planta',
    planting = 'Plantando...',
    planted = 'Has plantado una semilla',
    plant_status = 'Planta al %d%%. Lista en %d min',
    plant_ready = 'La planta está lista',
    not_owner = 'Esta planta no es tuya',
    harvesting = 'Recolectando...',
    harvested = 'Has recogido %dx %s',
    plant_busy = 'Alguien ya está recogiendo esta planta',

    street_sold = 'Has vendido %dx %s por %d €',
    street_refused = 'No me interesa',
    street_served = 'Esta persona ya ha tratado contigo',
    no_item = 'No tienes %s',

    offer_sent = 'Oferta enviada',
    offer_title = 'Oferta de marihuana',
    offer_content = 'Te ofrecen **%dx Marihuana** por **%d €**. ¿Aceptas?',
    offer_accepted = 'Trato cerrado: %dx Marihuana por %d €',
    offer_rejected = 'La oferta ha sido rechazada',
    offer_expired = 'La oferta ha caducado',
    offer_pending = 'Ya hay una oferta pendiente',
    offer_failed = 'El trato no se ha podido completar',

    gather_hint = '[%s] Recolectar',
    gathering = 'Recolectando...',
    gathered = 'Has recolectado %dx %s',
    processing = 'Procesando...',
    processed = 'Has obtenido %dx %s',
    need_items = 'Necesitas %dx %s',

    island_sell = 'Vender opio en cantidad',
    island_sold = 'Has vendido %dx %s por %d €',
}
