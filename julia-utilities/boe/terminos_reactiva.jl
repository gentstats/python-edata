using CSV, DataFrames

# https://www.boe.es/diario_boe/txt.php?id=BOE-A-2023-26251

# b) Precios de los términos de energía reactiva inductiva:
# Periodos 	cos φ 	€/kVArh
# Periodos 1 a 5. 	cos φ ≥ 0,95 	0,0000000
# 0,80 ≤ cos φ < 0,95 	0,0415540
# cos φ < 0,80 	0,0623320

# c) Precios de los términos de energía reactiva capacitiva:
# Periodos 	cos φ 	€/kVArh
# Periodo 6. 	cos φ < 0,98 	0,0000000

get_term_reactive = function (cos_phi, period)

    terms_reactive = Dict(
        ">=0.95" => [0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        "<=0.8&<0.95" => [0.0415540, 0.0415540, 0.0415540, 0.0415540, 0.0415540, 0.0],
        "<0.8" => [0.0623320, 0.0623320, 0.0623320, 0.0623320, 0.0623320, 0.0]
    )
    if period < 1 || period > 6
        return "Invalid period"
    end
    if cos_phi >= 0.95
        return terms_reactive[">=0.95"][period]
    elseif cos_phi < 0.95 && cos_phi >= 0.8
        return terms_reactive["<=0.8&<0.95"][period]
    else
        return terms_reactive["<0.8"][period]
    end
end


