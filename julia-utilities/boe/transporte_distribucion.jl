using CSV, DataFrames


# Los términos de energía:
# Grupo tarifario 	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 2.0 TD 	0,004528 	0,002589 	0,000075 	  	  	 
# 3.0 TD 	0,005720 	0,002979 	0,001785 	0,001301 	0,000085 	0,000055
# 6.1 TD 	0,005224 	0,002713 	0,001742 	0,001273 	0,000081 	0,000049
# 6.2 TD 	0,004401 	0,002283 	0,001423 	0,001044 	0,000066 	0,000040
# 6.3 TD 	0,005280 	0,002858 	0,001839 	0,001323 	0,000086 	0,000052
# 6.4 TD 	0,008757 	0,004806 	0,003067 	0,002206 	0,000139 	0,000089
# Grupo tarifario 	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 2.0 TD 	0,028553 	0,016595 	0,000482 	  	  	 
# 3.0 TD 	0,018254 	0,009841 	0,005788 	0,004194 	0,000339 	0,000179
# 6.1 TD 	0,016675 	0,008962 	0,005652 	0,004103 	0,000325 	0,000163
# 6.2 TD 	0,007471 	0,004247 	0,002263 	0,001730 	0,000183 	0,000050
# 6.3 TD 	0,005119 	0,002793 	0,001764 	0,001336 	0,000152 	0,000088
# 6.4 TD 	– 	– 	– 	– 	– 	–
# Grupo tarifario 	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 2.0 TD 	0,033081 	0,019184 	0,000557 	  	  	 
# 3.0 TD 	0,023974 	0,012820 	0,007573 	0,005495 	0,000424 	0,000234
# 6.1 TD 	0,021899 	0,011675 	0,007394 	0,005376 	0,000406 	0,000212
# 6.2 TD 	0,011872 	0,006530 	0,003686 	0,002774 	0,000249 	0,000090
# 6.3 TD 	0,010399 	0,005651 	0,003603 	0,002659 	0,000238 	0,000140
# 6.4 TD 	0,008757 	0,004806 	0,003067 	0,002206 	0,000139 	0,000089

get_term_energia_peaje_transporte = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de energía
    energy_term_charges = Dict(
        "2.0TD" => [0.004528, 0.002589, 0.000075, 0.0, 0.0, 0.0],
        "3.0TD" => [0.005720, 0.002979, 0.001785, 0.001301, 0.000085, 0.000055],
        "6.1TD" => [0.005224, 0.002713, 0.001742, 0.001273, 0.000081, 0.000049],
        "6.2TD" => [0.004401, 0.002283, 0.001423, 0.001044, 0.000066, 0.000040],
        "6.3TD" => [0.005280, 0.002858, 0.001839, 0.001323, 0.000086, 0.000052],
        "6.4TD" => [0.008757, 0.004806, 0.003067, 0.002206, 0.000139, 0.000089]
    )
    # Devuelve los datos de los términos de energía para la tarifa dada
    energy_charges = get(energy_term_charges, tariff_code, "Tariff code not found")
    if energy_charges === "Tariff code not found"
        return energy_charges
    elseif period === nothing
        return energy_charges
    elseif period < 1 || period > length(energy_charges)
        return "Invalid period"
    else
        return energy_charges[period]
    end
end

get_term_energia_peaje_distribucion = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de energía
    energy_term_charges = Dict(
        "2.0TD" => [0.028553, 0.016595, 0.000482, 0.0, 0.0, 0.0],
        "3.0TD" => [0.018254, 0.009841, 0.005788, 0.004194, 0.000339, 0.000179],
        "6.1TD" => [0.016675, 0.008962, 0.005652, 0.004103, 0.000325, 0.000163],
        "6.2TD" => [0.007471, 0.004247, 0.002263, 0.001730, 0.000183, 0.000050],
        "6.3TD" => [0.005119, 0.002793, 0.001764, 0.001336, 0.000152, 0.000088],
        "6.4TD" => [0.0, 0, 0, 0, 0, 0]
    )
    # Devuelve los datos de los términos de energía para la tarifa dada
    energy_charges = get(energy_term_charges, tariff_code, "Tariff code not found")
    if energy_charges === "Tariff code not found"
        return energy_charges
    elseif period === nothing
        return energy_charges
    elseif period < 1 || period > length(energy_charges)
        return "Invalid period"
    else
        return energy_charges[period]
    end
end

get_term_energia_peaje_transporte_distribucion = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de energía
    energy_term_charges = Dict(
        "2.0TD" => [0.033081, 0.019184, 0.000557, 0.0, 0.0, 0.0],
        "3.0TD" => [0.023974, 0.012820, 0.007573, 0.005495, 0.000424, 0.000234],
        "6.1TD" => [0.021899, 0.011675, 0.007394, 0.005376, 0.000406, 0.000212],
        "6.2TD" => [0.011872, 0.006530, 0.003686, 0.002774, 0.000249, 0.000090],
        "6.3TD" => [0.010399, 0.005651, 0.003603, 0.002659, 0.000238, 0.000140],
        "6.4TD" => [0.008757, 0.004806, 0.003067, 0.002206, 0.000139, 0.000089]
    )
    # Devuelve los datos de los términos de energía para la tarifa dada
    energy_charges = get(energy_term_charges, tariff_code, "Tariff code not found")
    if energy_charges === "Tariff code not found"
        return energy_charges
    elseif period === nothing
        return energy_charges
    elseif period < 1 || period > length(energy_charges)
        return "Invalid period"
    else
        return energy_charges[period]
    end
end
















# https://www.boe.es/diario_boe/txt.php?id=BOE-A-2023-26251

# Los términos de potencia contratada
# Grupo tarifario 	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 2.0 TD 	3,117200 	0,039102 	  	  	  	 
# 3.0 TD 	1,547750 	1,009391 	0,440585 	0,358447 	0,042635 	0,042635
# 6.1 TD 	5,038316 	3,101868 	2,385032 	1,892034 	0,078114 	0,078114
# 6.2 TD 	4,905550 	3,148751 	2,144498 	1,723336 	0,093775 	0,093775
# 6.3 TD 	5,436815 	3,407131 	2,678037 	2,034190 	0,131927 	0,131927
# 6.4 TD 	7,310560 	4,116430 	3,161822 	2,877385 	0,194493 	0,194493
# Grupo tarifario 	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 2.0 TD 	19,284546 	0,737462 	  	  	  	 
# 3.0 TD 	10,450080 	6,678414 	2,866852 	2,433339 	0,891800 	0,891800
# 6.1 TD 	15,519534 	9,661016 	7,541219 	5,956346 	0,247027 	0,247027
# 6.2 TD 	8,232863 	5,602456 	3,471172 	2,947782 	0,144700 	0,144700
# 6.3 TD 	5,037478 	3,103289 	2,563687 	2,104645 	0,209538 	0,209538
# 6.4 TD 	– 	– 	– 	– 	– 	–
# Grupo tarifario 	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 2.0 TD 	22,401746 	0,776564 	  	  	  	 
# 3.0 TD 	11,997830 	7,687805 	3,307437 	2,791786 	0,934435 	0,934435
# 6.1 TD 	20,557850 	12,762884 	9,926251 	7,848380 	0,325141 	0,325141
# 6.2 TD 	13,138413 	8,751207 	5,615670 	4,671118 	0,238475 	0,238475
# 6.3 TD 	10,474293 	6,510420 	5,241724 	4,138835 	0,341465 	0,341465
# 6.4 TD 	7,310560 	4,116430 	3,161822 	2,877385 	0,194493 	0,194493

get_term_potencia_peaje_transporte = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de potencia contratada
    power_term_charges = Dict(
        "2.0TD" => [3.117200, 0.039102, 0, 0, 0, 0],
        "3.0TD" => [1.547750, 1.009391, 0.440585, 0.358447, 0.042635, 0.042635],
        "6.1TD" => [5.038316, 3.101868, 2.385032, 1.892034, 0.078114, 0.078114],
        "6.2TD" => [4.905550, 3.148751, 2.144498, 1.723336, 0.093775, 0.093775],
        "6.3TD" => [5.436815, 3.407131, 2.678037, 2.034190, 0.131927, 0.131927],
        "6.4TD" => [7.310560, 4.116430, 3.161822, 2.877385, 0.194493, 0.194493]
    )
    # Devuelve los datos de los términos de potencia contratada para la tarifa dada
    power_charges = get(power_term_charges, tariff_code, "Tariff code not found")
    if power_charges === "Tariff code not found"
        return power_charges
    elseif period === nothing
        return power_charges
    elseif period < 1 || period > length(power_charges)
        return "Invalid period"
    else
        return power_charges[period]
    end
end

get_term_potencia_peaje_distribucion = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de potencia contratada
    power_term_charges = Dict(
        "2.0TD" => [19.284546, 0.737462, 0, 0, 0, 0],
        "3.0TD" => [10.450080, 6.678414, 2.866852, 2.433339, 0.891800, 0.891800],
        "6.1TD" => [15.519534, 9.661016, 7.541219, 5.956346, 0.247027, 0.247027],
        "6.2TD" => [8.232863, 5.602456, 3.471172, 2.947782, 0.144700, 0.144700],
        "6.3TD" => [5.037478, 3.103289, 2.563687, 2.104645, 0.209538, 0.209538],
        "6.4TD" => [0.0, 0, 0, 0, 0, 0]
    )
    # Devuelve los datos de los términos de potencia contratada para la tarifa dada
    power_charges = get(power_term_charges, tariff_code, "Tariff code not found")
    if power_charges === "Tariff code not found"
        return power_charges
    elseif period === nothing
        return power_charges
    elseif period < 1 || period > length(power_charges)
        return "Invalid period"
    else
        return power_charges[period]
    end
end

get_term_potencia_peaje_transporte_distribucion = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de potencia contratada
    power_term_charges = Dict(
        "2.0TD" => [22.401746, 0.776564, 0, 0, 0, 0],
        "3.0TD" => [11.997830, 7.687805, 3.307437, 2.791786, 0.934435, 0.934435],
        "6.1TD" => [20.557850, 12.762884, 9.926251, 7.848380, 0.325141, 0.325141],
        "6.2TD" => [13.138413, 8.751207, 5.615670, 4.671118, 0.238475, 0.238475],
        "6.3TD" => [10.474293, 6.510420, 5.241724, 4.138835, 0.341465, 0.341465],
        "6.4TD" => [7.310560, 4.116430, 3.161822, 2.877385, 0.194493, 0.194493]
    )
    # Devuelve los datos de los términos de potencia contratada para la tarifa dada
    power_charges = get(power_term_charges, tariff_code, "Tariff code not found")
    if power_charges === "Tariff code not found"
        return power_charges
    elseif period === nothing
        return power_charges
    elseif period < 1 || period > length(power_charges)
        return "Invalid period"
    else
        return power_charges[period]
    end
end













