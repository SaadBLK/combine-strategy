// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © mrhili

//@version=5

activate_ema_strategy = input(title='Activate EMA STRATEGY ?', defval=true)

//EMA STRATEGY
indicator(title='combine stragegies', shorttitle='CMB', overlay=true, format=format.inherit , max_bars_back=500)
ema20 = ta.ema(close, 20)
ema50 = ta.ema(close, 50)
ema100 = ta.ema(close, 100)
ema200 = ta.ema(close, 200)


//EMA20
plot(activate_ema_strategy? ema20 : na, title='ema 20', color=color.new(color.yellow, 0), linewidth=1)

//EMA50
plot(activate_ema_strategy? ema50 : na, title='ema 50', color=color.new(color.blue, 0), linewidth=1)

//EMA100
plot(activate_ema_strategy? ema100 : na, title='ema 100', color=color.new(color.green, 0), linewidth=3)

//EMA200
plot(activate_ema_strategy? ema200 : na, title='ema 200', color=color.new(color.orange, 0), linewidth=3)



//END EMA STRATEGY
//********************************************************
//ZLSMA STRATEGY

activate_zlsma_strategy = input(title='Activate ZLSMA STRATEGY ?', defval=true)

lenghtZLSMA = input(45, "zlsma lenght")
offsetZLSMA = input(0, "zlsma offset")
sourceZLSMA = input(close, "zlsma source")

lsma = ta.linreg(sourceZLSMA, lenghtZLSMA, offsetZLSMA)
lsma2 = ta.linreg(lsma,lenghtZLSMA , offsetZLSMA)
eqZLSMA= lsma-lsma2
zlsma = lsma+eqZLSMA


plot(activate_zlsma_strategy? zlsma : na, title='zlsma', color=color.new(color.black, 50), linewidth=4)

//END ZLSMA STRATEGY
//*************************************************************

//CHANDELIER EXIT Start

activate_ce1_strategy = input(title='Activate CE 1 STRATEGY ?', defval=true)


lengthCE = input(title='ATR Period', defval=1)
multCE = input.float(title='ATR Multiplier', step=0.1, defval=1.5)
showLabelsCE = input(title='Show Buy/Sell Labels ?', defval=true)
useCloseCE =  input(title='Use Close Price for Extremums ?', defval=false)
highlightStateCE = input(title='Highlight State ?', defval=false)

atrCE = multCE * ta.atr(lengthCE)

longStop = (useCloseCE ? ta.highest(close, lengthCE) : ta.highest(lengthCE)) - atrCE
longStopPrev = nz(longStop[1], longStop)
longStop := close[1] > longStopPrev ? math.max(longStop, longStopPrev) : longStop

shortStop = (useCloseCE ? ta.lowest(close, lengthCE) : ta.lowest(lengthCE)) + atrCE
shortStopPrev = nz(shortStop[1], shortStop)
shortStop := close[1] < shortStopPrev ? math.min(shortStop, shortStopPrev) : shortStop

var int dir = 1
dir := close > shortStopPrev ? 1 : close < longStopPrev ? -1 : dir

var color longColor = color.green
var color shortColor = color.red

longStopPlot = plot(dir == 1 ? longStop : na, title='Long Stop', style=plot.style_linebr, linewidth=2, color=longColor)
buySignal = dir == 1 and dir[1] == -1
plotshape(buySignal and activate_ce1_strategy ? longStop : na, title='Long Stop Start', location=location.absolute, style=shape.circle, size=size.tiny, color=longColor, transp=0)
plotshape(buySignal and showLabelsCE and activate_ce1_strategy ? longStop : na, title='Buy Label', text='Buy', location=location.absolute, style=shape.labelup, size=size.tiny, color=longColor, textcolor=color.new(color.white, 0), transp=0)

shortStopPlot = plot(dir == 1 ? na : shortStop, title='Short Stop', style=plot.style_linebr, linewidth=2, color=shortColor)
sellSignal = dir == -1 and dir[1] == 1
plotshape(sellSignal and activate_ce1_strategy ? shortStop : na, title='Short Stop Start', location=location.absolute, style=shape.circle, size=size.tiny, color=shortColor, transp=0)
plotshape(sellSignal and showLabelsCE and activate_ce1_strategy ? shortStop : na, title='Sell Label', text='Sell', location=location.absolute, style=shape.labeldown, size=size.tiny, color=shortColor, textcolor=color.new(color.white, 0), transp=0)

midPricePlot = plot(ohlc4, title='', style=plot.style_circles, linewidth=0, display=display.none, editable=false)

longFillColor = highlightStateCE ? dir == 1 ? longColor : na : na
shortFillColor = highlightStateCE ? dir == -1 ? shortColor : na : na

fill_transparency_CE1 = 90

if activate_ce1_strategy
    fill_transparency_CE1 = 100

    
fill(midPricePlot, longStopPlot, title='Long State Filling', color=longFillColor, transp=fill_transparency_CE1)
fill(midPricePlot, shortStopPlot, title='Short State Filling', color=shortFillColor, transp=fill_transparency_CE1)


changeCond = dir != dir[1]
alertcondition(changeCond, title='Alert: CE Direction Change', message='Chandelier Exit has changed direction!')
alertcondition(buySignal, title='Alert: CE Buy', message='Chandelier Exit Buy!')
alertcondition(sellSignal, title='Alert: CE Sell', message='Chandelier Exit Sell!')

//END OF CE STOP

//********************************

//CHANDELIER EXIT STRAT2

activate_ce2_strategy = input(title='Activate CE 2 STRATEGY ?', defval=true)


lengthCE2 = input(title='ATR Period 2', defval=22)
multCE2 = input.float(title='ATR Multiplier 2', step=0.1, defval=3.0)
showLabelsCE2 = input(title='Show Buy/Sell Labels ? (2)', defval=true)
useCloseCE2 =  input(title='Use Close Price for Extremums ? (2)', defval=true)
highlightStateCE2 = input(title='Highlight State ? (2)', defval=false)

atrCE2 = multCE2 * ta.atr(lengthCE2)

longStop2 = (useCloseCE2 ? ta.highest(close, lengthCE2) : ta.highest(lengthCE2)) - atrCE2
longStopPrev2 = nz(longStop2[1], longStop2)
longStop2 := close[1] > longStopPrev2 ? math.max(longStop2, longStopPrev2) : longStop2

shortStop2 = (useCloseCE2 ? ta.lowest(close, lengthCE2) : ta.lowest(lengthCE2)) + atrCE2
shortStopPrev2 = nz(shortStop2[1], shortStop2)
shortStop2 := close[1] < shortStopPrev2 ? math.min(shortStop2, shortStopPrev2) : shortStop2

var int dir2 = 1
dir2 := close > shortStopPrev2 ? 1 : close < longStopPrev2 ? -1 : dir2

var color longColor2 = color.teal
var color shortColor2 = color.fuchsia


longStopPlot2 = plot(dir2 == 1 ? longStop2 : na, title='Long Stop 2', style=plot.style_linebr, linewidth=2, color=longColor2)
buySignal2 = dir2 == 1 and dir2[1] == -1
plotshape(buySignal2 and activate_ce2_strategy ? longStop2 : na, title='Long Stop Start 2', location=location.absolute, style=shape.circle, size=size.tiny, color=longColor2, transp=0)
plotshape(buySignal2 and showLabelsCE2 and activate_ce2_strategy ? longStop2 : na, title='Buy Label 2', text='Buy 2', location=location.absolute, style=shape.labelup, size=size.tiny, color=longColor2, textcolor=color.new(color.white, 0), transp=0)

shortStopPlot2 = plot(dir2 == 1 ? na : shortStop2, title='Short Stop 2', style=plot.style_linebr, linewidth=2, color=shortColor2)
sellSignal2 = dir2 == -1 and dir2[1] == 1
plotshape(sellSignal2 and activate_ce2_strategy ? shortStop2 : na, title='Short Stop Start 2', location=location.absolute, style=shape.circle, size=size.tiny, color=shortColor2, transp=0)
plotshape(sellSignal2 and showLabelsCE2 and activate_ce2_strategy ? shortStop2 : na, title='Sell Label 2', text='Sell 2', location=location.absolute, style=shape.labeldown, size=size.tiny, color=shortColor2, textcolor=color.new(color.white, 0), transp=0)

midPricePlot2 = plot(ohlc4, title='', style=plot.style_circles, linewidth=0, display=display.none, editable=false)

longFillColor2 = highlightStateCE2 ? dir == 1 ? longColor2 : na : na
shortFillColor2 = highlightStateCE2 ? dir == -1 ? shortColor2 : na : na

//TODO
fill_transparency_CE2 = 90

if activate_ce2_strategy
    fill_transparency_CE2 = 100
    
fill(midPricePlot2, longStopPlot2, title='Long State Filling 2', color=longFillColor2, transp=fill_transparency_CE2)
fill(midPricePlot2, shortStopPlot2, title='Short State Filling 2', color=shortFillColor2, transp=fill_transparency_CE2)

changeCond2 = dir2 != dir2[1]
alertcondition(changeCond2, title='Alert: CE 2 Direction Change', message='Chandelier Exit 2 has changed direction!')
alertcondition(buySignal2, title='Alert: CE 2 Buy', message='Chandelier Exit 2 Buy!')
alertcondition(sellSignal2, title='Alert: CE 2 Sell', message='Chandelier Exit 2 Sell!')

//END OF CE2 STOP


//DIVERGENCE FR MANY v4
//******************************



//indicator(title='combine stragegies', shorttitle='CMB', overlay=true, format=format.inherit)


//activate_div4_strategy = input(title='Activate DIVERGENCE FORMANY V4 STRATEGY ?', defval=true)
activate_div4_strategy = true

//prdDIV4 = input.int(defval=5, title='Pivot Period', minval=1, maxval=50)
prdDIV4 = input.int(defval=3, title='Pivot Period', minval=1, maxval=50)
sourceDIV4 = input.string(defval='Close', title='Source for Pivot Points', options=['Close', 'High/Low'])
searchdiv_DIV4 = input.string(defval='Regular/Hidden', title='Divergence Type', options=['Regular', 'Hidden', 'Regular/Hidden'])
showindis_DIV4 = input.string(defval='Full', title='Show Indicator Names', options=['Full', 'First Letter', 'Don\'t Show'])
showlimit_DIV4 = input.int(1, title='Minimum Number of Divergence', minval=1, maxval=11)
maxpp_DIV4 = input.int(defval=10, title='Maximum Pivot Points to Check', minval=1, maxval=20)
maxbars_DIV4 = input.int(defval=100, title='Maximum Bars to Check', minval=30, maxval=200)
shownum_DIV4 = input(defval=true, title='Show Divergence Number')
//false
showlast_DIV4 = input(defval=true, title='Show Only Last Divergence')
//default was false
dontconfirm_DIV4 = input(defval=true, title='Don\'t Wait for Confirmation')
showlines_DIV4 = input(defval=true, title='Show Divergence Lines')
showpivot_DIV4 = input(defval=false, title='Show Pivot Points')
calcmacd_DIV4 = input(defval=true, title='MACD')
calcmacda_DIV4 = input(defval=true, title='MACD Histogram')
calcrsi_DIV4 = input(defval=true, title='RSI')
calcstoc_DIV4 = input(defval=true, title='Stochastic')
calccci_DIV4 = input(defval=true, title='CCI')
calcmom_DIV4 = input(defval=true, title='Momentum')
calcobv_DIV4 = input(defval=true, title='OBV')
calcvwmacd_DIV4 = input(true, title='VWmacd')
calccmf_DIV4 = input(true, title='Chaikin Money Flow')
calcmfi_DIV4 = input(true, title='Money Flow Index')
calcext_DIV4 = input(false, title='Check External Indicator')
externalindi_DIV4 = input(defval=close, title='External Indicator')
pos_reg_div_col_DIV4 = input(defval=color.yellow, title='Positive Regular Divergence')
neg_reg_div_col_DIV4 = input(defval=color.navy, title='Negative Regular Divergence')
pos_hid_div_col_DIV4 = input(defval=color.lime, title='Positive Hidden Divergence')
neg_hid_div_col_DIV4 = input(defval=color.red, title='Negative Hidden Divergence')
pos_div_text_col_DIV4 = input(defval=color.black, title='Positive Divergence Text Color')
neg_div_text_col_DIV4 = input(defval=color.white, title='Negative Divergence Text Color')
reg_div_l_style_DIV4_ = input.string(defval='Solid', title='Regular Divergence Line Style', options=['Solid', 'Dashed', 'Dotted'])
hid_div_l_style_DIV4_ = input.string(defval='Dashed', title='Hdden Divergence Line Style', options=['Solid', 'Dashed', 'Dotted'])
reg_div_l_width_DIV4 = input.int(defval=2, title='Regular Divergence Line Width', minval=1, maxval=5)
hid_div_l_width_DIV4 = input.int(defval=1, title='Hidden Divergence Line Width', minval=1, maxval=5)
showmas_DIV4 = input.bool(defval=false, title='Show MAs 50 & 200', inline='ma12')
cma1col_DIV4 = input.color(defval=color.lime, title='', inline='ma12')
cma2col_DIV4 = input.color(defval=color.red, title='', inline='ma12')

plot(showmas_DIV4 and activate_div4_strategy ? ta.sma(close, 50) : na, color=showmas_DIV4 ? cma1col_DIV4 : na)
plot(showmas_DIV4 and activate_div4_strategy ? ta.sma(close, 200) : na, color=showmas_DIV4 ? cma2col_DIV4 : na)

// set line styles
var reg_div_l_style_DIV4 = reg_div_l_style_DIV4_ == 'Solid' ? line.style_solid : reg_div_l_style_DIV4_ == 'Dashed' ? line.style_dashed : line.style_dotted
var hid_div_l_style_DIV4 = hid_div_l_style_DIV4_ == 'Solid' ? line.style_solid : hid_div_l_style_DIV4_ == 'Dashed' ? line.style_dashed : line.style_dotted


// get indicators
rsi_DIV4 = ta.rsi(close, 14)  // RSI
[macd_DIV4, signal, deltamacd_DIV4] = ta.macd(close, 12, 26, 9)  // MACD
moment = ta.mom(close, 10)  // Momentum
cci_DIV4 = ta.cci(close, 10)  // CCI
Obv_DIV4 = ta.obv  // OBV
stk_DIV4 = ta.sma(ta.stoch(close, high, low, 14), 3)  // Stoch
maFast_DIV4 = ta.vwma(close, 12)  // volume weighted macd
maSlow_DIV4 = ta.vwma(close, 26)
vwmacd_DIV4 = maFast_DIV4 - maSlow_DIV4
Cmfm_DIV4 = (close - low - (high - close)) / (high - low)  // Chaikin money flow
Cmfv_DIV4 = Cmfm_DIV4 * volume
cmf_DIV4 = ta.sma(Cmfv_DIV4, 21) / ta.sma(volume, 21)
Mfi_DIV4 = ta.mfi(close, 14)  // Moneyt Flow Index

// keep indicators names and colors in arrays
var indicators_name_DIV4 = array.new_string(11)
var div_colors_DIV4 = array.new_color(4)
if barstate.isfirst
    // names
    array.set(indicators_name_DIV4, 0, showindis_DIV4 == 'Full' ? 'MACD' : 'M')
    array.set(indicators_name_DIV4, 1, showindis_DIV4 == 'Full' ? 'Hist' : 'H')
    array.set(indicators_name_DIV4, 2, showindis_DIV4 == 'Full' ? 'RSI' : 'E')
    array.set(indicators_name_DIV4, 3, showindis_DIV4 == 'Full' ? 'Stoch' : 'S')
    array.set(indicators_name_DIV4, 4, showindis_DIV4 == 'Full' ? 'CCI' : 'C')
    array.set(indicators_name_DIV4, 5, showindis_DIV4 == 'Full' ? 'MOM' : 'M')
    array.set(indicators_name_DIV4, 6, showindis_DIV4 == 'Full' ? 'OBV' : 'O')
    array.set(indicators_name_DIV4, 7, showindis_DIV4 == 'Full' ? 'VWMACD' : 'V')
    array.set(indicators_name_DIV4, 8, showindis_DIV4 == 'Full' ? 'CMF' : 'C')
    array.set(indicators_name_DIV4, 9, showindis_DIV4 == 'Full' ? 'MFI' : 'M')
    array.set(indicators_name_DIV4, 10, showindis_DIV4 == 'Full' ? 'Extrn' : 'X')
    //colors
    array.set(div_colors_DIV4, 0, pos_reg_div_col_DIV4)
    array.set(div_colors_DIV4, 1, neg_reg_div_col_DIV4)
    array.set(div_colors_DIV4, 2, pos_hid_div_col_DIV4)
    array.set(div_colors_DIV4, 3, neg_hid_div_col_DIV4)

// Check if we get new Pivot High Or Pivot Low
float ph_DIV4_ = ta.pivothigh(sourceDIV4 == 'Close' ? close : high, prdDIV4, prdDIV4)
float pl_DIV4_ = ta.pivotlow(sourceDIV4 == 'Close' ? close : low, prdDIV4, prdDIV4)
plotshape(ph_DIV4_ and showpivot_DIV4 and activate_div4_strategy, text='H', style=shape.labeldown, color=color.new(color.white, 100), textcolor=color.new(color.red, 0), location=location.abovebar, offset=-prdDIV4)
plotshape(pl_DIV4_ and showpivot_DIV4 and activate_div4_strategy, text='L', style=shape.labelup, color=color.new(color.white, 100), textcolor=color.new(color.lime, 0), location=location.belowbar, offset=-prdDIV4)

// keep values and positions of Pivot Highs/Lows in the arrays
var int maxarraysize_DIV4 = 20
var ph_DIV4__positions = array.new_int(maxarraysize_DIV4, 0)
var pl_DIV4__positions = array.new_int(maxarraysize_DIV4, 0)
var ph_DIV4__vals = array.new_float(maxarraysize_DIV4, 0.)
var pl_DIV4__vals = array.new_float(maxarraysize_DIV4, 0.)

// add PHs to the array
if ph_DIV4_
    array.unshift(ph_DIV4__positions, bar_index)
    array.unshift(ph_DIV4__vals, ph_DIV4_)
    if array.size(ph_DIV4__positions) > maxarraysize_DIV4
        array.pop(ph_DIV4__positions)
        array.pop(ph_DIV4__vals)

// add PLs to the array
if pl_DIV4_
    array.unshift(pl_DIV4__positions, bar_index)
    array.unshift(pl_DIV4__vals, pl_DIV4_)
    if array.size(pl_DIV4__positions) > maxarraysize_DIV4
        array.pop(pl_DIV4__positions)
        array.pop(pl_DIV4__vals)

// functions to check Regular Divergences and Hidden Divergences

// function to check positive regular or negative hidden divergence
// cond == 1 => positive_regular, cond == 2=> negative_hidden
positive_regular_positive_hidden_divergence(src, cond) =>
    divlen = 0
    prsc = sourceDIV4 == 'Close' ? close : low
    // if indicators higher than last value and close price is higher than las close 
    if dontconfirm_DIV4 or src > src[1] or close > close[1]
        startpoint = dontconfirm_DIV4 ? 0 : 1  // don't check last candle
        // we search last 15 PPs
        for x = 0 to maxpp_DIV4 - 1 by 1
            len = bar_index - array.get(pl_DIV4__positions, x) + prdDIV4
            // if we reach non valued array element or arrived 101. or previous bars then we don't search more
            if array.get(pl_DIV4__positions, x) == 0 or len > maxbars_DIV4
                break
            if len > 5 and (cond == 1 and src[startpoint] > src[len] and prsc[startpoint] < nz(array.get(pl_DIV4__vals, x)) or cond == 2 and src[startpoint] < src[len] and prsc[startpoint] > nz(array.get(pl_DIV4__vals, x)))
                slope1 = (src[startpoint] - src[len]) / (len - startpoint)
                virtual_line1 = src[startpoint] - slope1
                slope2 = (close[startpoint] - close[len]) / (len - startpoint)
                virtual_line2 = close[startpoint] - slope2
                arrived_DIV4 = true
                for y = 1 + startpoint to len - 1 by 1
                    if src[y] < virtual_line1 or nz(close[y]) < virtual_line2
                        arrived_DIV4 := false
                        break
                    virtual_line1 := virtual_line1 - slope1
                    virtual_line2 := virtual_line2 - slope2
                    virtual_line2

                if arrived_DIV4
                    divlen := len
                    break
    divlen

// function to check negative regular or positive hidden divergence
// cond == 1 => negative_regular, cond == 2=> positive_hidden
negative_regular_negative_hidden_divergence(src, cond) =>
    divlen = 0
    prsc = sourceDIV4 == 'Close' ? close : high
    // if indicators higher than last value and close price is higher than las close 
    if dontconfirm_DIV4 or src < src[1] or close < close[1]
        startpoint = dontconfirm_DIV4 ? 0 : 1  // don't check last candle
        // we search last 15 PPs
        for x = 0 to maxpp_DIV4 - 1 by 1
            len = bar_index - array.get(ph_DIV4__positions, x) + prdDIV4
            // if we reach non valued array element or arrived 101. or previous bars then we don't search more
            if array.get(ph_DIV4__positions, x) == 0 or len > maxbars_DIV4
                break
            if len > 5 and (cond == 1 and src[startpoint] < src[len] and prsc[startpoint] > nz(array.get(ph_DIV4__vals, x)) or cond == 2 and src[startpoint] > src[len] and prsc[startpoint] < nz(array.get(ph_DIV4__vals, x)))
                slope1 = (src[startpoint] - src[len]) / (len - startpoint)
                virtual_line1 = src[startpoint] - slope1
                slope2 = (close[startpoint] - nz(close[len])) / (len - startpoint)
                virtual_line2 = close[startpoint] - slope2
                arrived_DIV4 = true
                for y = 1 + startpoint to len - 1 by 1
                    if src[y] > virtual_line1 or nz(close[y]) > virtual_line2
                        arrived_DIV4 := false
                        break
                    virtual_line1 := virtual_line1 - slope1
                    virtual_line2 := virtual_line2 - slope2
                    virtual_line2

                if arrived_DIV4
                    divlen := len
                    break
    divlen

// calculate 4 types of divergence if enabled in the options and return divergences in an array
calculate_divs(cond, indicator_1) =>
    divs = array.new_int(4, 0)
    array.set(divs, 0, cond and (searchdiv_DIV4 == 'Regular' or searchdiv_DIV4 == 'Regular/Hidden') ? positive_regular_positive_hidden_divergence(indicator_1, 1) : 0)
    array.set(divs, 1, cond and (searchdiv_DIV4 == 'Regular' or searchdiv_DIV4 == 'Regular/Hidden') ? negative_regular_negative_hidden_divergence(indicator_1, 1) : 0)
    array.set(divs, 2, cond and (searchdiv_DIV4 == 'Hidden' or searchdiv_DIV4 == 'Regular/Hidden') ? positive_regular_positive_hidden_divergence(indicator_1, 2) : 0)
    array.set(divs, 3, cond and (searchdiv_DIV4 == 'Hidden' or searchdiv_DIV4 == 'Regular/Hidden') ? negative_regular_negative_hidden_divergence(indicator_1, 2) : 0)
    divs

// array to keep all divergences
var all_divergences_DIV4 = array.new_int(44)  // 11 indicators * 4 divergence = 44 elements
// set related array elements
array_set_divs(div_pointer, index) =>
    for x = 0 to 3 by 1
        array.set(all_divergences_DIV4, index * 4 + x, array.get(div_pointer, x))

// set divergences array 
array_set_divs(calculate_divs(calcmacd_DIV4, macd_DIV4), 0)
array_set_divs(calculate_divs(calcmacda_DIV4, deltamacd_DIV4), 1)
array_set_divs(calculate_divs(calcrsi_DIV4, rsi_DIV4), 2)
array_set_divs(calculate_divs(calcstoc_DIV4, stk_DIV4), 3)
array_set_divs(calculate_divs(calccci_DIV4, cci_DIV4), 4)
array_set_divs(calculate_divs(calcmom_DIV4, moment), 5)
array_set_divs(calculate_divs(calcobv_DIV4, Obv_DIV4), 6)
array_set_divs(calculate_divs(calcvwmacd_DIV4, vwmacd_DIV4), 7)
array_set_divs(calculate_divs(calccmf_DIV4, cmf_DIV4), 8)
array_set_divs(calculate_divs(calcmfi_DIV4, Mfi_DIV4), 9)
array_set_divs(calculate_divs(calcext_DIV4, externalindi_DIV4), 10)

// check minimum number of divergence, if less than showlimit_DIV4 then delete all divergence
total_div_DIV4 = 0
for x = 0 to array.size(all_divergences_DIV4) - 1 by 1
    total_div_DIV4 := total_div_DIV4 + math.round(math.sign(array.get(all_divergences_DIV4, x)))
    total_div_DIV4

if total_div_DIV4 < showlimit_DIV4
    array.fill(all_divergences_DIV4, 0)

// keep line in an array
var pos_div_lines = array.new_line(0)
var neg_div_lines = array.new_line(0)
var pos_div_labels = array.new_label(0)
var neg_div_labels = array.new_label(0)

// remove old lines and labels if showlast_DIV4 option is enabled
delete_old_pos_div_lines() =>
    if array.size(pos_div_lines) > 0
        for j = 0 to array.size(pos_div_lines) - 1 by 1
            line.delete(array.get(pos_div_lines, j))
        array.clear(pos_div_lines)

delete_old_neg_div_lines() =>
    if array.size(neg_div_lines) > 0
        for j = 0 to array.size(neg_div_lines) - 1 by 1
            line.delete(array.get(neg_div_lines, j))
        array.clear(neg_div_lines)

delete_old_pos_div_labels() =>
    if array.size(pos_div_labels) > 0
        for j = 0 to array.size(pos_div_labels) - 1 by 1
            label.delete(array.get(pos_div_labels, j))
        array.clear(pos_div_labels)

delete_old_neg_div_labels() =>
    if array.size(neg_div_labels) > 0
        for j = 0 to array.size(neg_div_labels) - 1 by 1
            label.delete(array.get(neg_div_labels, j))
        array.clear(neg_div_labels)

// delete last creted lines and labels until we met new PH/PV 
delete_last_pos_div_lines_label(n) =>
    if n > 0 and array.size(pos_div_lines) >= n
        asz = array.size(pos_div_lines)
        for j = 1 to n by 1
            line.delete(array.get(pos_div_lines, asz - j))
            array.pop(pos_div_lines)
        if array.size(pos_div_labels) > 0
            label.delete(array.get(pos_div_labels, array.size(pos_div_labels) - 1))
            array.pop(pos_div_labels)

delete_last_neg_div_lines_label(n) =>
    if n > 0 and array.size(neg_div_lines) >= n
        asz = array.size(neg_div_lines)
        for j = 1 to n by 1
            line.delete(array.get(neg_div_lines, asz - j))
            array.pop(neg_div_lines)
        if array.size(neg_div_labels) > 0
            label.delete(array.get(neg_div_labels, array.size(neg_div_labels) - 1))
            array.pop(neg_div_labels)

// variables for Alerts
pos_reg_div_detected_DIV4 = false
neg_reg_div_detected_DIV4 = false
pos_hid_div_detected_DIV4 = false
neg_hid_div_detected_DIV4 = false

// to remove lines/labels until we met new // PH/PL
var last_pos_div_lines_DIV4 = 0
var last_neg_div_lines_DIV4 = 0
var remove_last_pos_divs_DIV4 = false
var remove_last_neg_divs_DIV4 = false
if pl_DIV4_
    remove_last_pos_divs_DIV4 := false
    last_pos_div_lines_DIV4 := 0
    last_pos_div_lines_DIV4
if ph_DIV4_
    remove_last_neg_divs_DIV4 := false
    last_neg_div_lines_DIV4 := 0
    last_neg_div_lines_DIV4

// draw divergences lines and labels
divergence_text_top_DIV4 = ''
divergence_text_bottom_DIV4 = ''
distances_DIV4 = array.new_int(0)
dnumdiv_top_DIV4 = 0
dnumdiv_bottom_DIV4 = 0
top_label_col_DIV4 = color.white
bottom_label_col_DIV4 = color.white
old_pos_divs_can_be_removed_DIV4 = true
old_neg_divs_can_be_removed_DIV4 = true
startpoint = dontconfirm_DIV4 ? 0 : 1  // used for don't confirm option

for x = 0 to 10 by 1
    div_type = -1
    for y = 0 to 3 by 1
        if array.get(all_divergences_DIV4, x * 4 + y) > 0  // any divergence?
            div_type := y
            if y % 2 == 1
                dnumdiv_top_DIV4 := dnumdiv_top_DIV4 + 1
                top_label_col_DIV4 := array.get(div_colors_DIV4, y)
                top_label_col_DIV4
            if y % 2 == 0
                dnumdiv_bottom_DIV4 := dnumdiv_bottom_DIV4 + 1
                bottom_label_col_DIV4 := array.get(div_colors_DIV4, y)
                bottom_label_col_DIV4
            if not array.includes(distances_DIV4, array.get(all_divergences_DIV4, x * 4 + y))  // line not exist ?
                array.push(distances_DIV4, array.get(all_divergences_DIV4, x * 4 + y))
                new_line = showlines_DIV4 ? line.new(x1=bar_index - array.get(all_divergences_DIV4, x * 4 + y), y1=sourceDIV4 == 'Close' ? close[array.get(all_divergences_DIV4, x * 4 + y)] : y % 2 == 0 ? low[array.get(all_divergences_DIV4, x * 4 + y)] : high[array.get(all_divergences_DIV4, x * 4 + y)], x2=bar_index - startpoint, y2=sourceDIV4 == 'Close' ? close[startpoint] : y % 2 == 0 ? low[startpoint] : high[startpoint], color=array.get(div_colors_DIV4, y), style=y < 2 ? reg_div_l_style_DIV4 : hid_div_l_style_DIV4, width=y < 2 ? reg_div_l_width_DIV4 : hid_div_l_width_DIV4) : na
                if y % 2 == 0
                    if old_pos_divs_can_be_removed_DIV4
                        old_pos_divs_can_be_removed_DIV4 := false
                        if not showlast_DIV4 and remove_last_pos_divs_DIV4
                            delete_last_pos_div_lines_label(last_pos_div_lines_DIV4)
                            last_pos_div_lines_DIV4 := 0
                            last_pos_div_lines_DIV4
                        if showlast_DIV4
                            delete_old_pos_div_lines()
                    array.push(pos_div_lines, new_line)
                    last_pos_div_lines_DIV4 := last_pos_div_lines_DIV4 + 1
                    remove_last_pos_divs_DIV4 := true
                    remove_last_pos_divs_DIV4

                if y % 2 == 1
                    if old_neg_divs_can_be_removed_DIV4
                        old_neg_divs_can_be_removed_DIV4 := false
                        if not showlast_DIV4 and remove_last_neg_divs_DIV4
                            delete_last_neg_div_lines_label(last_neg_div_lines_DIV4)
                            last_neg_div_lines_DIV4 := 0
                            last_neg_div_lines_DIV4
                        if showlast_DIV4
                            delete_old_neg_div_lines()
                    array.push(neg_div_lines, new_line)
                    last_neg_div_lines_DIV4 := last_neg_div_lines_DIV4 + 1
                    remove_last_neg_divs_DIV4 := true
                    remove_last_neg_divs_DIV4

            // set variables for alerts
            if y == 0
                pos_reg_div_detected_DIV4 := true
                pos_reg_div_detected_DIV4
            if y == 1
                neg_reg_div_detected_DIV4 := true
                neg_reg_div_detected_DIV4
            if y == 2
                pos_hid_div_detected_DIV4 := true
                pos_hid_div_detected_DIV4
            if y == 3
                neg_hid_div_detected_DIV4 := true
                neg_hid_div_detected_DIV4
    // get text for labels
    if div_type >= 0
        divergence_text_top_DIV4 := divergence_text_top_DIV4 + (div_type % 2 == 1 ? showindis_DIV4 != 'Don\'t Show' ? array.get(indicators_name_DIV4, x) + '\n' : '' : '')
        divergence_text_bottom_DIV4 := divergence_text_bottom_DIV4 + (div_type % 2 == 0 ? showindis_DIV4 != 'Don\'t Show' ? array.get(indicators_name_DIV4, x) + '\n' : '' : '')
        divergence_text_bottom_DIV4


// draw labels
if showindis_DIV4 != 'Don\'t Show' or shownum_DIV4
    if shownum_DIV4 and dnumdiv_top_DIV4 > 0
        divergence_text_top_DIV4 := divergence_text_top_DIV4 + str.tostring(dnumdiv_top_DIV4)
        divergence_text_top_DIV4
    if shownum_DIV4 and dnumdiv_bottom_DIV4 > 0
        divergence_text_bottom_DIV4 := divergence_text_bottom_DIV4 + str.tostring(dnumdiv_bottom_DIV4)
        divergence_text_bottom_DIV4
    if divergence_text_top_DIV4 != ''
        if showlast_DIV4
            delete_old_neg_div_labels()
        array.push(neg_div_labels, label.new(x=bar_index, y=math.max(high, high[1]), text=divergence_text_top_DIV4, color=top_label_col_DIV4, textcolor=neg_div_text_col_DIV4, style=label.style_label_down))

    if divergence_text_bottom_DIV4 != ''
        if showlast_DIV4
            delete_old_pos_div_labels()
        array.push(pos_div_labels, label.new(x=bar_index, y=math.min(low, low[1]), text=divergence_text_bottom_DIV4, color=bottom_label_col_DIV4, textcolor=pos_div_text_col_DIV4, style=label.style_label_up))


alertcondition(pos_reg_div_detected_DIV4, title='Positive Regular Divergence Detected', message='Positive Regular Divergence Detected')
alertcondition(neg_reg_div_detected_DIV4, title='Negative Regular Divergence Detected', message='Negative Regular Divergence Detected')
alertcondition(pos_hid_div_detected_DIV4, title='Positive Hidden Divergence Detected', message='Positive Hidden Divergence Detected')
alertcondition(neg_hid_div_detected_DIV4, title='Negative Hidden Divergence Detected', message='Negative Hidden Divergence Detected')

alertcondition(pos_reg_div_detected_DIV4 or pos_hid_div_detected_DIV4, title='Positive Divergence Detected', message='Positive Divergence Detected')
alertcondition(neg_reg_div_detected_DIV4 or neg_hid_div_detected_DIV4, title='Negative Divergence Detected', message='Negative Divergence Detected')

//********************************************
//END OF DIVERGENCE FR MANY v4



//******************************************************

//AUTO SUPPORT AND RESISTANCE START

activate_oto_sr_strategy = input(title='Activate Autosupport and resistance STRATEGY ?', defval=true)



lenW_otosupp = input.int(title="Number Candle of 1 Wave", defval=25, minval=1, confirm=true)
numsr_otosupp = input.int(title="Number of Support／Resistance", defval=5, minval=1, maxval=500, confirm=true)
supcol_otosupp = input.color(color.new(color.green, 85), title="Support", confirm=true)
rescol_otosupp = input.color(color.new(color.red, 85), title="Resistance", confirm=true)
breakoutmode_otosupp = input.bool(true, title="Breakout Mode", confirm=true)
var box[] boxes_otosupp = array.new_box()

srfun(src, len, isHigh_otosupp) =>
    p = nz(src[len])
    float q = na
    if isHigh_otosupp
        q := math.max(open[len], close[len])
    if not isHigh_otosupp
        q := math.min(open[len], close[len])
    colorbox = isHigh_otosupp ? rescol_otosupp : supcol_otosupp
    isFound = true
    for i = 0 to len - 1
        if isHigh_otosupp and src[i] > p
            isFound := false
        if not isHigh_otosupp and src[i] < p
            isFound := false
    for i = len + 1 to 2 * len
        if isHigh_otosupp and src[i] >= p
            isFound := false
        if not isHigh_otosupp and src[i] <= p
            isFound := false
    if isFound
        id = box.new(bar_index[len], p, bar_index, q, border_color = colorbox, bgcolor = colorbox)
        [id]
    else
        [box(na)]

if activate_oto_sr_strategy        
    [resbox_otosupp] = srfun(high, lenW_otosupp-1, true)
    [supbox_otosupp] = srfun(low, lenW_otosupp-1, false)


    if not na(resbox_otosupp)
        array.push(boxes_otosupp, resbox_otosupp)
    if not na(supbox_otosupp)
        array.push(boxes_otosupp, supbox_otosupp)

    if array.size(boxes_otosupp) > numsr_otosupp
        boxdl_supp = array.shift(boxes_otosupp)
        box.delete(boxdl_supp)

    if array.size(boxes_otosupp) != 0
        for i = array.size(boxes_otosupp)-1 to 0
            box = array.get(boxes_otosupp, i)
            y1 = box.get_top(box)
            y2 = box.get_bottom(box)
            box.set_right(box, bar_index)
            if close < math.min(y1, y2) and barstate.isconfirmed and breakoutmode_otosupp
                box.set_border_color(box, rescol_otosupp)
                box.set_bgcolor(box, rescol_otosupp)
            if close > math.max(y1, y2) and barstate.isconfirmed and breakoutmode_otosupp
                box.set_border_color(box, supcol_otosupp)
                box.set_bgcolor(box, supcol_otosupp)



watermarki_supp = input.bool(false, "Watermark", group="Author Sign", confirm=true)




string  i_tableYpos_oto_supp = input.string("top", "Position", inline = "12", options = ["top", "middle", "bottom"])
string  i_tableXpos_oto_supp = input.string("center", "", inline = "12", options = ["left", "center", "right"])
int     i_height_oto_supp    = input.int(5, "Height", minval = 1, maxval = 100, inline = "13")
int     i_width_oto_supp     = input.int(50, "Width",  minval = 1, maxval = 100, inline = "13a")
color   i_c_text_oto_supp    = input.color(color.new(color.white, 0), "", inline = "14")
color   _bg_oto_supp    = input.color(color.new(color.blue, 70), "", inline = "14")
string  i_textSize  = input.string("tiny", "Size", inline = "14", options = ["tiny", "small", "normal", "large", "huge", "auto"])
i_text2_supp =  "ｂｙ　Mumei"
i_text1_supp =  "When using the indicator" + "\n" + "thank you"
var table watermark_supp = table.new(i_tableYpos_oto_supp + "_" + i_tableXpos_oto_supp, 1, 1)
if barstate.islast and watermarki_supp
    varip bool _changeText_supp = true
    _changeText_supp := not _changeText_supp
    string _txt_supp = _changeText_supp ? i_text2_supp : i_text1_supp
    table.cell(watermark_supp, 0, 0, _txt_supp, i_width_oto_supp, i_height_oto_supp, i_c_text_oto_supp, text_size = i_textSize, bgcolor = _bg_oto_supp)

//END OF AUTO SUPPORT AND RESISTANCE 
//*******************************************************


// [pine]

// !<------ User Inputs -----> 
activate_consolidation_sr_strategy = input(title='Activate Consolidation range STRATEGY ?', defval=true)

fill_trancparency_consold = 85


if activate_consolidation_sr_strategy

    fill_trancparency_consold = 100


src_consold = input(close, title='Range Input (Default set to Close')
lengthEMA_consold = input(19, title='Length')
zoneToggle_consold = input(true, title='Toggle Zone Highlights')
iCol_consold = color.new(#FFFFFF, 70)
iCol_lowrange_consold = color.new(#e63946, 0)
iCol_highrange_consold = color.new(#1d3557, 0)

// !<---- Declarations & Calculations ---- > 
trndUp_consold = float(na)
trndDwn_consold = float(na)
mid_consold = float(na)
e_consold = ta.ema(src_consold, lengthEMA_consold)
trndUp_consold := src_consold < nz(trndUp_consold[1]) and src_consold > trndDwn_consold[1] ? nz(trndUp_consold[1]) : high
trndDwn_consold := src_consold < nz(trndUp_consold[1]) and src_consold > trndDwn_consold[1] ? nz(trndDwn_consold[1]) : low
mid_consold := math.avg(trndUp_consold, trndDwn_consold)

// !< ---- Plotting -----> 
highRange_consold = plot( (trndUp_consold == nz(trndUp_consold[1]) ) and activate_consolidation_sr_strategy ? trndUp_consold : na, color=iCol_highrange_consold, linewidth=2, style=plot.style_linebr, title='Top of Period Range')
lowRange_consold = plot( ( trndDwn_consold == nz(trndDwn_consold[1]) ) and activate_consolidation_sr_strategy ? trndDwn_consold : na, color=iCol_lowrange_consold, linewidth=2, style=plot.style_linebr, title='Bottom of Period Range')


xzone_consold = plot( zoneToggle_consold ? src_consold > e_consold  ? trndDwn_consold : trndUp_consold : na, color=iCol_consold, style=plot.style_circles, linewidth=0, editable=false)






fill(highRange_consold, xzone_consold, color=color.new(color.lime, fill_trancparency_consold))

fill(xzone_consold, lowRange_consold, color=color.new(color.red, fill_trancparency_consold))

//[/pine]


//*********************************************************
