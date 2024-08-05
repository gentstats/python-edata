using CSV, DataFrames


# Precios de los términos de potencia:
# Segmento tarifario 	Término de potencia de los cargos (euros/kW año)
# Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 1 	2,989915 	0,192288 	  	  	  	 
# 2 	3,715217 	1,859231 	1,350774 	1,350774 	1,350774 	0,619203
# 3 	3,856557 	1,930027 	1,402384 	1,402384 	1,402384 	0,642759
# 4 	2,264702 	1,133557 	0,823528 	0,823528 	0,823528 	0,377450
# 5 	1,813304 	0,907425 	0,659281 	0,659281 	0,659281 	0,302217
# 6 	0,887008 	0,443874 	0,322548 	0,322548 	0,322548 	0,147835

get_term_potencia_cargos = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de potencia de los cargos
    power_term_charges = Dict(
        "2.0TD" => [2.989915, 0.192288, 0, 0, 0, 0],
        "3.0TD" => [3.715217, 1.859231, 1.350774, 1.350774, 1.350774, 0.619203],
        "6.1TD" => [3.856557, 1.930027, 1.402384, 1.402384, 1.402384, 0.642759],
        "6.2TD" => [2.264702, 1.133557, 0.823528, 0.823528, 0.823528, 0.377450],
        "6.3TD" => [1.813304, 0.907425, 0.659281, 0.659281, 0.659281, 0.302217],
        "6.4TD" => [0.887008, 0.443874, 0.322548, 0.322548, 0.322548, 0.147835]
    )
    # Devuelve los datos de los términos de potencia de los cargos para el código de tarifa y periodo dados
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

# Precios de los términos de energía:
# Segmento tarifario 	Término de energía de los cargos (euros/kWh)
# Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 1 	0,043893 	0,008779 	0,002195 	  	  	 
# 2 	0,024469 	0,018118 	0,009788 	0,004894 	0,003137 	0,001958
# 3 	0,013305 	0,009856 	0,005322 	0,002661 	0,001706 	0,001064
# 4 	0,006243 	0,004624 	0,002497 	0,001249 	0,000800 	0,000499
# 5 	0,005117 	0,003791 	0,002047 	0,001023 	0,000656 	0,000409
# 6 	0,001944 	0,001440 	0,000778 	0,000389 	0,000249 	0,000156

get_term_energia_cargos = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de energía de los cargos
    energy_term_charges = Dict(
        "2.0TD" => [0.043893, 0.008779, 0.002195, 0, 0, 0],
        "3.0TD" => [0.024469, 0.018118, 0.009788, 0.004894, 0.003137, 0.001958],
        "6.1TD" => [0.013305, 0.009856, 0.005322, 0.002661, 0.001706, 0.001064],
        "6.2TD" => [0.006243, 0.004624, 0.002497, 0.001249, 0.000800, 0.000499],
        "6.3TD" => [0.005117, 0.003791, 0.002047, 0.001023, 0.000656, 0.000409],
        "6.4TD" => [0.001944, 0.001440, 0.000778, 0.000389, 0.000249, 0.000156]
    )
    # Devuelve los datos de los términos de energía de los cargos para el código de tarifa y periodo dados
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






# https://www.boe.es/diario_boe/txt.php?id=BOE-A-2024-2774

# Los precios unitarios de aplicación para la financiación de los pagos por capacidad a partir del 15 de febrero de 2024, regulados en el anexo III de la Orden ITC/2794/2007, de 27 de septiembre, por la que se revisan las tarifas eléctricas a partir del 1 de octubre de 2007, y en la Orden ITC/3127/2011, de 17 de noviembre, por la que se regula el servicio de disponibilidad de potencia de los pagos por capacidad y se modifica el incentivo a la inversión al que hace referencia el anexo III de la Orden ITC/2794/2007, de 27 de septiembre, aplicables por la energía adquirida por los sujetos a los que se refiere la disposición adicional séptima de la Orden ITC/3860/2007, de 28 de diciembre, por la que se revisan las tarifas eléctricas a partir del 1 de enero de 2008, son:
# Segmento tarifario 	 Término de energía de los pagos por capacidad (euros/kWh), en b.c.
#   	Periodo 1 	Periodo 2 	Periodo 3 	Periodo 4 	Periodo 5 	Periodo 6
# 1 	0,000926 	0,000154 	  	  	  	 
# 2 	0,001251 	0,000578 	0,000385 	0,000289 	0,000289 	 
# 3 	0,000537 	0,000247 	0,000165 	0,000124 	0,000124 	 
# 4 	0,000537 	0,000247 	0,000165 	0,000124 	0,000124 	 
# 5 	0,000537 	0,000247 	0,000165 	0,000124 	0,000124 	 
# 6 	0,000537 	0,000247 	0,000165 	0,000124 	0,000124

get_term_energia_pagos_capacidad = function (tariff_code, period=nothing)
    # Diccionario con los datos de los términos de energía de los pagos por capacidad
    energy_term_charges = Dict(
        "2.0TD" => [0.000926, 0.000154, 0, 0, 0, 0],
        "3.0TD" => [0.001251, 0.000578, 0.000385, 0.000289, 0.000289, 0],
        "6.1TD" => [0.000537, 0.000247, 0.000165, 0.000124, 0.000124, 0],
        "6.2TD" => [0.000537, 0.000247, 0.000165, 0.000124, 0.000124, 0],
        "6.3TD" => [0.000537, 0.000247, 0.000165, 0.000124, 0.000124, 0],
        "6.4TD" => [0.000537, 0.000247, 0.000165, 0.000124, 0.000124, 0]
    )
    # Devuelve los datos de los términos de energía de los pagos por capacidad para el código de tarifa y periodo dados
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






