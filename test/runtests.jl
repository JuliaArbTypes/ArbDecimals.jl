using ArbDecimals
using Base.Test

setprecision(BigFloat,167)
bf167 = string(atan(log(BigFloat(golden))))
setprecision(BigFloat,250)
bf250 = atan(log(BigFloat(golden)))
dbf = abs(bf250 - parse(BigFloat,bf167))
ad = atan(log(Dec50(golden)))
daf = abs(atan(log(Dec75(golden))) - ad)

@test stringall(Dec50(golden)) == "1.6180339887498948482045868343656381177203091798058"
@test stringsmall(Dec50(golden)) == stringsmall(Dec100(golden))
@test dbf > daf
