using DataFrames

get_coef_perdidas = function (tariff_code, period=nothing)
    # Diccionario con los datos de los coeficientes de pérdidas
    loss_coefficients = Dict(
        "2.0TD" => [16.7, 16.3, 18.0, 0, 0, 0] ./ 100 .+ 1,
        "3.0TD" => [16.6, 17.5, 16.5, 16.5, 13.8, 18.0] ./ 100 .+ 1,
        "6.1TD" => [6.7, 6.8, 6.5, 6.5, 4.3, 7.7] ./ 100 .+ 1,
        "6.2TD" => [5.2, 5.4, 4.9, 5.0, 3.5, 5.4] ./ 100 .+ 1,
        "6.3TD" => [4.2, 4.3, 4.0, 4.0, 3.0, 4.4] ./ 100 .+ 1,
        "6.4TD" => [1.6, 1.6, 1.6, 1.6, 1.5, 1.7 ./ 100 .+ 1]
    )
    # Devuelve los datos de los coeficientes de pérdidas para la tarifa dada
    loss_coefficients = get(loss_coefficients, tariff_code, "Tariff code not found")
    if loss_coefficients === "Tariff code not found"
        return loss_coefficients
    elseif period === nothing
        return loss_coefficients
    elseif period < 1 || period > length(loss_coefficients)
        return "Invalid period"
    else
        return loss_coefficients[period]
    end
end
