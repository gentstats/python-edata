using HTTP, DataFrames, Dates, CSV, Plots, JSON, Statistics


gen_esios_request_start_end_dates = function (y, m)
    from_date = DateTime(y, m, 1, 0, 0, 0, 0)
    from_date = Dates.format(Date(y, m, 1), "yyyy-mm-ddT00%3A00%3A00%2B02%3A00")
    to_date = DateTime(y, m, Dates.daysinmonth(Date(y, m)), 23, 55, 0, 0)
    to_date = Dates.format(Date(y, m, Dates.daysinmonth(Date(y, m))), "yyyy-mm-ddT23%3A55%3A00%2B02%3A00")
    return from_date, to_date
end

get_esios_servicios_ajuste = function (y, m)
    start_date, end_date = gen_esios_request_start_end_dates(y, m)
    url = "https://api.esios.ree.es/indicators/1871?start_date=$start_date&end_date=$end_date&geo_ids[]=8741&geo_agg=sum&time_trunc=hour&locale=es"
    res = HTTP.get(url,
              ["Accept" => "application/json", "X-API-KEY" => "request_your_personal_token_sending_email_to_consultasios@ree.es"],
              readtimeout=3
          ).body |> String |> JSON.parse
    res = res["indicator"]["values"] |> DataFrame
    # 2024-06-30T23:00:00.000+02:00
    res.datetime = DateTime.(map(x -> x[1:19], res.datetime), "yyyy-mm-ddTHH:MM:SS")
    return rename(select(res, [:datetime, :value]), :value => :ajustes)

end

# get_esios_precio_suma_componentes = function (y, m)
#     start_date, end_date = gen_esios_request_start_end_dates(y, m)
#     url = "https://api.esios.ree.es/indicators/10211?start_date=$start_date&end_date=$end_date&geo_ids=&geo_agg=sum&time_trunc=hour&locale=es"
#     res = HTTP.get(url,
#               ["Accept" => "application/json", "X-API-KEY" => "request_your_personal_token_sending_email_to_consultasios@ree.es"],
#               readtimeout=3
#           ).body |> String |> JSON.parse
#     res = res["indicator"]["values"] |> DataFrame
#     res.datetime = DateTime.(map(x -> x[1:19], res.datetime), "yyyy-mm-ddTHH:MM:SS")
#     return rename(select(res, [:datetime, :value]), :value => :suma_componentes)
# end

get_esios_baleares = function (y, m)
    start_date, end_date = gen_esios_request_start_end_dates(y, m)
    url = "https://api.esios.ree.es/indicators/573?start_date=$start_date&end_date=$end_date&geo_ids[]=8743&geo_agg=sum&time_trunc=hour&locale=es"
    res = HTTP.get(url,
              ["Accept" => "application/json", "X-API-KEY" => "request_your_personal_token_sending_email_to_consultasios@ree.es"],
              readtimeout=3
          ).body |> String |> JSON.parse
    res = res["indicator"]["values"] |> DataFrame
    res.datetime = DateTime.(map(x -> x[1:19], res.datetime), "yyyy-mm-ddTHH:MM:SS")
    return rename(select(res, [:datetime, :value]), :value => :baleares)
end

get_esios_mercado_diario = function (y, m)
    start_date, end_date = gen_esios_request_start_end_dates(y, m)
    url = "https://api.esios.ree.es/indicators/805?start_date=$start_date&end_date=$end_date&geo_ids=&geo_agg=sum&time_trunc=hour&locale=es"
    res = HTTP.get(url,
              ["Accept" => "application/json", "X-API-KEY" => "request_your_personal_token_sending_email_to_consultasios@ree.es"],
              readtimeout=3
          ).body |> String |> JSON.parse
    res = res["indicator"]["values"] |> DataFrame
    res.datetime = DateTime.(map(x -> x[1:19], res.datetime), "yyyy-mm-ddTHH:MM:SS")
    return rename(select(res, [:datetime, :value]), :value => :diario)
end

get_esios_desvios = function (y, m)
    start_date, end_date = gen_esios_request_start_end_dates(y, m)
    url = "https://api.esios.ree.es/indicators/768?start_date=$start_date&end_date=$end_date&geo_ids=&geo_agg=sum&time_trunc=hour&locale=es"
    res = HTTP.get(url,
              ["Accept" => "application/json", "X-API-KEY" => "request_your_personal_token_sending_email_to_consultasios@ree.es"],
              readtimeout=3
          ).body |> String |> JSON.parse
    res = res["indicator"]["values"] |> DataFrame
    res.datetime = DateTime.(map(x -> x[1:19], res.datetime), "yyyy-mm-ddTHH:MM:SS")
    return rename(select(res, [:datetime, :value]), :value => :desvios)
end

get_esios_demanda_programada = function (y, m)
    start_date, end_date = gen_esios_request_start_end_dates(y, m)
    url = "https://api.esios.ree.es/indicators/365?start_date=$start_date&end_date=$end_date&geo_ids=&geo_agg=sum&time_trunc=hour&locale=es"
    res = HTTP.get(url,
              ["Accept" => "application/json", "X-API-KEY" => "request_your_personal_token_sending_email_to_consultasios@ree.es"],
              readtimeout=3
          ).body |> String |> JSON.parse
    res = res["indicator"]["values"] |> DataFrame
    res.datetime = DateTime.(map(x -> x[1:19], res.datetime), "yyyy-mm-ddTHH:MM:SS")
    return rename(select(res, [:datetime, :value]), :value => :demanda_programada)
end

get_esios_year_month_and_combine = function (y, m)
    res = get_esios_servicios_ajuste(y, m)
    # res = leftjoin(res, get_esios_precio_suma_componentes(y, m), on=:datetime)
    # res = leftjoin(res, get_esios_desvios(y, m), on=:datetime)
    res = leftjoin(res, get_esios_mercado_diario(y, m), on=:datetime)
    res = leftjoin(res, get_esios_baleares(y, m), on=:datetime)
    res = leftjoin(res, get_esios_demanda_programada(y, m), on=:datetime)
    return res
end

# download_esios_data = function ()
#     to_year = year(now())
#     from_year = ifelse(reset == true, 2020, year(now()) - 1)
#     res = []
#     for year in from_year:to_year
#         for month in 1:12
#             println("Downloading data for $year-$month")
#             try
#                 push!(res, get_esios_year_month_and_combine(year, month))
#             catch e
#                 println(e)
#                 println("Failed to get data for $year-$month")
#             end
#         end
#     end
#     res = reduce(vcat, res)
#     res = res[completecases(res), :]
#     select!(res, [:datetime, :ajustes, :baleares, :diario, :demanda_programada])
#     DataFrames.sort!(res, :datetime)
#     CSV.write("data/esios/esios_data.csv", res)
#     return true
# end

# download_esios_data()