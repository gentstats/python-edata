using CSV, DataFrames

# Pte. revisar la fórmula para las 6.1
# https://www.energigreen.com/tarifas-electricidad/tarifa-6-1td/


# https://www.boe.es/diario_boe/txt.php?id=BOE-A-2023-26251

# puntos de suministro con tipo medida 4 y 5
# 2.0 TD 	3.0 TD 	6.1 TD 	6.2 TD 	6.3 TD 	6.4 TD
# 0,099060 	0,111643 	0,117264 	0,108910 	0,099256 	0,095864
# puntos de suministro con tipo medida 1, 2 y 3 ---------------------------> (P > 50kW) 
# 2.0 TD 	3.0 TD 	6.1 TD 	6.2 TD 	6.3 TD 	6.4 TD
# 3,013070 	3,395810 	3,566788 	3,312680 	3,019048 	2,915852


get_excess_penalty_prices = function (tariff_code, measure_type=2)
    # Diccionario con los precios de penalización por exceso de potencia para cada tarifa y tipo de medida
    excess_penalty = Dict(
        "2.0TD" => [3.013070, 0.099060],
        "3.0TD" => [3.395810, 0.111643],
        "3.0TDVE" => [3.395810, 0.111643],
        "6.1TD" => [3.566788, 0.117264],
        "6.1TDVE" => [3.566788, 0.117264],
        "6.2TD" => [3.312680, 0.108910],
        "6.3TD" => [3.019048, 0.099256],
        "6.4TD" => [2.915852, 0.095864]
    )
    # Obtener los precios de penalización para la tarifa y tipo de medida dados
    penalty_prices = get(excess_penalty, tariff_code, "Tariff code not found")
    # Devolver el precio de penalización si la tarifa existe y el tipo de medida es válido
    if penalty_prices === "Tariff code not found"
        return penalty_prices
    elseif measure_type < 1 || measure_type > 2
        return "Invalid measure type"
    else
        return penalty_prices[measure_type]
    end
end

# Periodo 	2.0 TD 	3.0 TD 	6.1 TD 	6.2 TD 	6.3 TD 	6.4 TD
# 1 	1,000000 	1,000000 	1,000000 	1,000000 	1,000000 	1,000000
# 2 	0,034665 	0,640766 	0,620828 	0,666078 	0,621562 	0,563080
# 3 	0           0,275670 	0,482845 	0,427424 	0,500437 	0,432501
# 4 	0           0,232691 	0,381770 	0,355531 	0,395142 	0,393593
# 5 	0           0,077884 	0,015816 	0,018151 	0,032600 	0,026604
# 6 	0           0,077884 	0,015816 	0,018151 	0,032600 	0,026604

get_excess_penalty_coefficients = function (tariff_code, period=nothing)
    # Diccionario con los coeficientes de penalización por exceso de potencia para cada tarifa y periodo
    excess_penalty = Dict(
        "2.0TD" => [1.0, 0.034665, 0, 0, 0, 0],
        "3.0TD" => [1.0, 0.640766, 0.275670, 0.232691, 0.077884, 0.077884],
        "6.1TD" => [1.0, 0.620828, 0.482845, 0.381770, 0.015816, 0.015816],
        "6.2TD" => [1.0, 0.666078, 0.427424, 0.355531, 0.018151, 0.018151],
        "6.3TD" => [1.0, 0.621562, 0.500437, 0.395142, 0.032600, 0.032600],
        "6.4TD" => [1.0, 0.563080, 0.432501, 0.393593, 0.026604, 0.026604]
    )
    # Devuelve los coeficientes de penalización por exceso de potencia para la tarifa y periodo dados
    penalties_for_tariff = get(excess_penalty, tariff_code, "Tariff code not found")
    if penalties_for_tariff === "Tariff code not found"
        return penalties_for_tariff
    elseif period === nothing
        return penalties_for_tariff
    elseif period < 1 || period > length(penalties_for_tariff)
        return "Invalid period"
    else
        return penalties_for_tariff[period]
    end
end


get_power_excess = function (power_contracted, power_demand)
    # Cálculo del exceso de potencia
    if power_demand <= (power_contracted * 1.05)
        return -1
    else
        return (power_demand - power_contracted * 1.05) * 2
    end
end

get_power_excess_penalty_per_day = function (power_contracted, power_demand, tariff_code, period, measure_type=2)
    # Cálculo de la penalización por exceso de potencia
    excess = get_power_excess(power_contracted, power_demand)
    penalty_coefficient = 1 # get_excess_penalty_coefficients(tariff_code, period)
    penalty_price = get_excess_penalty_prices(tariff_code, measure_type)
    if excess <= 0.0
        return 0.0
    else
        return excess * penalty_coefficient * penalty_price
    end
end

# get_power_excess_penalty_per_day(10, 15, "3.0TD", 1, 2)

get_power_excess_penalty = function (df, dfinfo)
    dfinfo = DataFrame(dfinfo)
    n_days = Dates.value.(df.FechaFinMesConsumo) .- Dates.value.(df.FechaInicioMesConsumo)
    penalty_values = map(p -> get_power_excess_penalty_per_day.(
            # df[!, Symbol("PotP$p")],
            repeat([dfinfo[1, Symbol("PotP$p")]], nrow(df)),
            df[!, Symbol("PReq$p" * "KWh")],
            repeat([dfinfo.Tarifa[1]], nrow(df)),
            repeat([p], nrow(df))
        ) .* n_days, 1:6) |> x ->
        DataFrame(x, [:PenaltyP1, :PenaltyP2, :PenaltyP3, :PenaltyP4, :PenaltyP5, :PenaltyP6])
    return penalty_values
end
