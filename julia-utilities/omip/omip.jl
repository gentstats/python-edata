using HTTP, Dates, DataFrames, JSON

jabali_resp_to_df = function (resp)
    try
        data = resp.body |> String
        data = split(data, "data-chart=")[2]
        data = data[2:(end-8)]
        data = JSON.parse(data)
    catch
        error("Parsear la respuesta de OMIP ha fallado")
    end
    if length(data["series"]) == 1
        data = data["series"][1]["data"]
        data = map(x -> Dict("datetime" => float(x[1]), "price" => float(x[2])), data) |> DataFrame
        data.date = Date.(unix2datetime.(data.datetime ./ 1000))
        return select(data, [:date, :price])
    elseif length(data["series"]) == 2
        volumes = data["series"][1]["data"]
        volumes = map(x -> Dict("datetime" => float(x[1]), "volume" => float(x[2])), volumes) |> DataFrame
        volumes.date = Date.(unix2datetime.(volumes.datetime ./ 1000))
        prices = data["series"][2]["data"]
        prices = map(x -> Dict("datetime" => float(x[1]), "price" => float(x[2])), prices) |> DataFrame
        prices.date = Date.(unix2datetime.(prices.datetime ./ 1000))
        leftjoin!(prices, volumes, on=:date, makeunique=true)
        prices.volume .= float.(prices.volume)
        return select(prices, [:date, :volume, :price])
    else
        error("Respuesta de OMIP, Longitud de series no soportada")
    end
end

get_omip_quarter_futures_data = function (q, y)
    url = "https://www.omip.pt/es/javali/get_full_chart/FTBQ$q-$y/0/1"
    res = HTTP.get(url, timeout=5)
    return jabali_resp_to_df(res)
end

get_omip_spel_data = function ()
    url = "https://www.omip.pt/es/javali/get_spot_chart/SPELBASE/0/1"
    res = HTTP.get(url)
    return jabali_resp_to_df(res)
end

# download_omip_data = function ()
#     for y in 15:(year(now())-2000)
#         for q in 1:4
#             try
#                 data = get_omip_quarter_futures_data(q, y)
#                 CSV.write("data/omip/FTBQ$q-$y.csv", data)
#             catch e
#                 println("Error en $y Q$q")
#             end
#         end
#     end
#     return data
# end

# get_omip_qy = function (q, y)
#     data = CSV.read("data/omip/FTBQ$q-$y.csv", DataFrame)
#     return data
# end

# get_omip_qy_close = function (q, y)
#     data = get_omip_qy(q, y)
#     return mean(last(data.price, 3))
# end

