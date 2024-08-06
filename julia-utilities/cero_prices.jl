include("../datasources/esios/esios.jl")
include("boe/include.jl")
using Dates, DataFrames, CSV, Statistics

get_omie_weighted_average_for_range = function (from_date, to_date)
    pdf = @view esios_data[Date.(esios_data.datetime).>=from_date.&&Date.(esios_data.datetime).<=to_date, :]
    pdf.value = pdf.diario .* pdf.demanda_programada
    return sum(pdf.value) / sum(pdf.demanda_programada)
end

# get_omie_for_range = function (from_date, to_date)
#     pdf = esios_data[Date.(esios_data.datetime).>=from_date.&&Date.(esios_data.datetime).<=to_date, :]
#     select!(pdf, [:datetime, :diario, :demanda_programada])
#     rename!(pdf, :diario => :precio, :demanda_programada => :demanda)
#     return pdf
# end

get_omie_daily_weighted_for_range = function (from_date, to_date)
    pdf = esios_data[Date.(esios_data.datetime).>=from_date.&&Date.(esios_data.datetime).<=to_date, :]
    pdf.value = pdf.diario .* pdf.demanda_programada
    pdf.date = Date.(pdf.datetime)
    pdf = combine(groupby(pdf, :date), :value => sum, :demanda_programada => sum)
    pdf.price = pdf.value_sum ./ pdf.demanda_programada_sum
    return select(pdf, [:date, :price])
end

# get_omie_for_range(Date(2023, 1, 1), Date(2023, 12, 31))
# get_omie_daily_weighted_for_range(Date(2023, 1, 1), Date(2023, 12, 31))

get_cero_prices = function (;
    tarifa="3.0TD",
    from_date=Date(2023, 1, 1),
    to_date=Date(2023, 12, 31),
    region="Baleares",
    mdc=0,
    tipo="todos" # o "precio" "ponderado" "fijo"
)

    pdf = esios_data[Date.(esios_data.datetime).>=from_date.&&Date.(esios_data.datetime).<=to_date, :]
    # tarifa = tariff_code #repeat([tariff_code], nrow(pdf))
    # region = repeat([region], nrow(pdf))
    period = get_period_number.(pdf.datetime, region, tarifa)
    pe = ifelse.(region == "Baleares", pdf.baleares, pdf.diario)
    aj = pdf.ajustes
    desv = ifelse(region == "Baleares", -8, -2) # ifelse(region == "Baleares", -2, 10)
    ppc = get_term_energia_pagos_capacidad.(tarifa, period) .* 1000
    osom = 0.26 # repeat([0.26], nrow(pdf))
    perd = get_coef_perdidas.(tarifa, period)
    # mdc = repeat([0.05], nrow(pdf))
    ipm = 0.05 #repeat([0.05], nrow(pdf))
    peaje = get_term_energia_peaje_transporte_distribucion.(tarifa, period) .* 1000
    cargos = get_term_energia_cargos.(tarifa, period) .* 1000
    te = ((pe .+ aj .+ desv .+ ppc .+ osom) .* perd .+ mdc) .* (1 .+ ipm ./ (1 .- ipm)) .+ peaje .+ cargos
    # tp = get_term_potencia_peaje_transporte_distribucion(tarifa) .+ get_term_potencia_cargos(tarifa)
    # tp = tp[period] ./ daysinyear.(pdf.datetime)
    prices_resume = DataFrame(
        datetime=pdf.datetime,
        te=te,
        # tp=tp,
        period=period,
        demanda=pdf.demanda_programada
    )
    prices_resume.valor = prices_resume.te .* prices_resume.demanda
    # prices_resume
    res = combine(groupby(prices_resume, [:period]),
        :demanda => mean,
        :te => mean => :precio,
        :valor => sum,
        :demanda => sum)
    res.precio_ponderado = res.valor_sum ./ res.demanda_sum
    res = leftjoin(DataFrame(period=1:6, x=1:6), res, on=:period)
    sort!(res, :period)
    res[ismissing.(res.precio), :precio] .= 0
    res[ismissing.(res.demanda_mean), :demanda_mean] .= 0
    res[ismissing.(res.precio_ponderado), :precio_ponderado] .= 0
    res[ismissing.(res.valor_sum), :valor_sum] .= 0
    res[ismissing.(res.demanda_sum), :demanda_sum] .= 0
    res.precio_fijo .= sum(res.valor_sum) / sum(res.demanda_sum)

    if tipo == "fijo"
        return float.(res.precio_fijo)
    elseif tipo == "ponderado"
        return float.(res.precio_ponderado)
    elseif tipo == "precio"
        return float.(res.precio)
    elseif tipo == "todos"
        return select(res, [:period, :precio, :precio_ponderado, :precio_fijo])
    elseif tipo == "tabla"
        return select(prices_resume, [:datetime, :period, :te, :demanda])
    else
        error("Tipo requerido no soportado")
    end
end

# get_cero_prices(tarifa="2.0TD", from_date=Date(2024, 1, 1), to_date=Date(2025, 6, 30), region="Peninsula", mdc=0, tipo="todos")
# get_term_potencia_peaje_transporte_distribucion("3.0TD") ./ 365
# sum(get_term_potencia_peaje_transporte_distribucion("3.0TD"))

