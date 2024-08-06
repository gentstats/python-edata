
using Dates, DataFrames, CSV, Statistics, Plots

# For a 2.0TD, find the number of P that matches with specified time 

get_period_number_20 = function (datetime)
    # Check if the day is Saturday or Sunday
    if Dates.dayofweek(datetime) in [6, 7]
        return 3
    end
    # Extract the hour from the datetime
    hour = Dates.hour(datetime)
    # Determine the number based on the hour
    if hour < 8
        return 3
    elseif hour >= 8 && hour < 10
        return 2
    elseif hour >= 10 && hour < 14
        return 1
    elseif hour >= 14 && hour < 18
        return 2
    elseif hour >= 18 && hour < 22
        return 1
    else
        return 2
    end
end

# Existen cuatro temporadas
# Cada día se le asigna un tipo de día
# A = Alta, B = Media Alta, B1 = Media,
# C = baja, D = Sábados, domingos, festivos y 6 de enero
# A cada tipo, se le asignan periodos horarios y números de potencia diferentes

# BALEARES
# Tipo A = 6, 7, 8, 9
# Tipo B = 5, 10
# Tipo B1 = 3, 4, 12
# Tipo C = 3, 4, 11
# Tipo D = Sábados, domingos, festivos y 6 de enero

get_day_type_baleares = function (datetime)
    month = Dates.month(datetime)
    dayofweek = Dates.dayofweek(datetime)
    if dayofweek in [6, 7] || (month == 1 && Dates.day(datetime) == 6)
        return "D"
    elseif month in [6, 7, 8, 9]
        return "A"
    elseif month in [5, 10]
        return "B"
    elseif month in [3, 4, 12]
        return "B1"
    elseif month in [1, 2, 11]
        return "C"
    else
        return "D"
    end
end


# PENINSULA
# Tipo A = 1, 2, 7, 12
# Tipo B = 3, 11
# Tipo B1 = 6, 8, 9
# Tipo C = 4, 5, 10
# Tipo D = Sábados, domingos, festivos y 6 de enero

get_day_type_peninsula = function (datetime)
    month = Dates.month(datetime)
    dayofweek = Dates.dayofweek(datetime)
    if dayofweek in [6, 7] || (month == 1 && Dates.day(datetime) == 6)
        return "D"
    elseif month in [1, 2, 7, 12]
        return "A"
    elseif month in [3, 11]
        return "B"
    elseif month in [6, 8, 9]
        return "B1"
    elseif month in [4, 5, 10]
        return "C"
    else
        return "D"
    end
end



# Para Baleares
# Los tramos horarios son los siguientes

# Tipo A 
# 1: 10 a 15 y 18 a 22
# 2: 8 a 10, 15 a 18 y 22 a 24
# 6: 0 a 8

# Tipo B
# 2: 10 a 15 y 18 a 22
# 3: 8 a 10, 15 a 18 y 22 a 24
# 6: 0 a 8

# Tipo B1
# 3: 10 a 15 y 18 a 22
# 4: 8 a 10, 15 a 18 y 22 a 24
# 6: 0 a 8

# Tipo C
# 4: 10 a 15 y 18 a 22
# 5: 8 a 10, 15 a 18 y 22 a 24
# 6: 0 a 8

# Tipo D
# 6: 0 a 24

get_period_number_baleares = function (datetime)
    day_type = get_day_type_baleares(datetime)
    hour = Dates.hour(datetime)
    if day_type == "A"
        if (hour >= 10 && hour < 15) || (hour >= 18 && hour < 22)
            return 1
        elseif (hour >= 8 && hour < 10) || (hour >= 15 && hour < 18) || (hour >= 22 && hour < 24)
            return 2
        else
            return 6
        end
    elseif day_type == "B"
        if (hour >= 10 && hour < 15) || (hour >= 18 && hour < 22)
            return 2
        elseif (hour >= 8 && hour < 10) || (hour >= 15 && hour < 18) || (hour >= 22 && hour < 24)
            return 3
        else
            return 6
        end
    elseif day_type == "B1"
        if (hour >= 10 && hour < 15) || (hour >= 18 && hour < 22)
            return 3
        elseif (hour >= 8 && hour < 10) || (hour >= 15 && hour < 18) || (hour >= 22 && hour < 24)
            return 4
        else
            return 6
        end
    elseif day_type == "C"
        if (hour >= 10 && hour < 15) || (hour >= 18 && hour < 22)
            return 4
        elseif (hour >= 8 && hour < 10) || (hour >= 15 && hour < 18) || (hour >= 22 && hour < 24)
            return 5
        else
            return 6
        end
    else
        return 6
    end
end


# Para Península
# Los tramos horarios son los siguientes

# Tipo A 
# 1: 9-14 y 18-22
# 2: 8-9, 14-18 y 22-24
# 6: 0-8

# Tipo B
# 2: 9-14 y 18-22
# 3: 8-9, 14-18 y 22-24
# 6: 0-8

# Tipo B1
# 3: 9-14 y 18-22
# 4: 8-9, 14-18 y 22-24
# 6: 0-8

# Tipo C
# 4: 9-14 y 18-22
# 5: 8-9, 14-18 y 22-24
# 6: 0-8

# Tipo D
# 6: 0-24

get_period_number_peninsula = function (datetime)
    day_type = get_day_type_peninsula(datetime)
    hour = Dates.hour(datetime)
    if day_type == "A"
        if (hour >= 9 && hour < 14) || (hour >= 18 && hour < 22)
            return 1
        elseif (hour >= 8 && hour < 9) || (hour >= 14 && hour < 18) || (hour >= 22 && hour < 24)
            return 2
        else
            return 6
        end
    elseif day_type == "B"
        if (hour >= 9 && hour < 14) || (hour >= 18 && hour < 22)
            return 2
        elseif (hour >= 8 && hour < 9) || (hour >= 14 && hour < 18) || (hour >= 22 && hour < 24)
            return 3
        else
            return 6
        end
    elseif day_type == "B1"
        if (hour >= 9 && hour < 14) || (hour >= 18 && hour < 22)
            return 3
        elseif (hour >= 8 && hour < 9) || (hour >= 14 && hour < 18) || (hour >= 22 && hour < 24)
            return 4
        else
            return 6
        end
    elseif day_type == "C"
        if (hour >= 9 && hour < 14) || (hour >= 18 && hour < 22)
            return 4
        elseif (hour >= 8 && hour < 9) || (hour >= 14 && hour < 18) || (hour >= 22 && hour < 24)
            return 5
        else
            return 6
        end
    else
        return 6
    end
end

# La función final 
# Recibe la fecha, la región y el código de tarifa
# Devuelve el número de periodo correspondiente

get_period_number = function (datetime, region, tariff_code)
    if tariff_code == "2.0TD"
        return get_period_number_20(datetime)
    elseif region == "Baleares"
        return get_period_number_baleares(datetime)
    else
        return get_period_number_peninsula(datetime)
    end
end

# get_period_code = function(period_number, tariff_code = "2.0TD")
#     if tariff_code == "2.0TD"
#         if period_number == 1
#             return "P"
#         elseif period_number == 2
#             return "L"
#         else
#             return "V"
#         end
#     elseif tariff_code == "3.0TD"

# end








# include("../cero_prices.jl")
# to_date = Date(now())# Date.(year(now()), month(now())) - Day(1)
# from_date = to_date - Month(12) + Day(1)

# pen = get_cero_prices(tarifa="3.0TD", from_date=from_date, to_date=to_date, region="Peninsula", mdc=0, tipo = "tabla")
# bal = get_cero_prices(tarifa="3.0TD", from_date=from_date, to_date=to_date, region="Baleares", mdc=0, tipo = "tabla")

# plot(pen.datetime, pen.period, alpha=0.35, color = :steelblue, label="Peninsula", size = (1200, 1200))
# plot!(bal.datetime, bal.period, alpha=0.35, color = :coral, label="Baleares")





# futuros 
# Carga base; todos los días todas las horas 
# Carga punta; L-V 8 a 8

