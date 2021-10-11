// This source code is subject to the terms of the Mozilla Public License 2.0 at https://mozilla.org/MPL/2.0/
// © mrhili

//@version=5

//EMA STRATEGY
indicator(title='combine stragegies', shorttitle='CMB', overlay=true, format=format.inherit)
ema20 = ta.ema(close, 20)
ema50 = ta.ema(close, 50)
ema100 = ta.ema(close, 100)
ema200 = ta.ema(close, 200)
//END EMA STRATEGY

//ZLSMA STRATEGY

lenghtZLSMA = input(45, "zlsma lenght")
offsetZLSMA = input(0, "zlsma offset")
sourceZLSMA = input(close, "zlsma source")

lsma = ta.linreg(sourceZLSMA, lenghtZLSMA, offsetZLSMA)
lsma2 = ta.linreg(lsma,lenghtZLSMA , offsetZLSMA)
eqZLSMA= lsma-lsma2
zlsma = lsma+eqZLSMA
//END ZLSMA STRATEGY

//CHANDELIER EXIT STRAT
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
plotshape(buySignal ? longStop : na, title='Long Stop Start', location=location.absolute, style=shape.circle, size=size.tiny, color=longColor, transp=0)
plotshape(buySignal and showLabelsCE ? longStop : na, title='Buy Label', text='Buy', location=location.absolute, style=shape.labelup, size=size.tiny, color=longColor, textcolor=color.new(color.white, 0), transp=0)

shortStopPlot = plot(dir == 1 ? na : shortStop, title='Short Stop', style=plot.style_linebr, linewidth=2, color=shortColor)
sellSignal = dir == -1 and dir[1] == 1
plotshape(sellSignal ? shortStop : na, title='Short Stop Start', location=location.absolute, style=shape.circle, size=size.tiny, color=shortColor, transp=0)
plotshape(sellSignal and showLabelsCE ? shortStop : na, title='Sell Label', text='Sell', location=location.absolute, style=shape.labeldown, size=size.tiny, color=shortColor, textcolor=color.new(color.white, 0), transp=0)

midPricePlot = plot(ohlc4, title='', style=plot.style_circles, linewidth=0, display=display.none, editable=false)

longFillColor = highlightStateCE ? dir == 1 ? longColor : na : na
shortFillColor = highlightStateCE ? dir == -1 ? shortColor : na : na
fill(midPricePlot, longStopPlot, title='Long State Filling', color=longFillColor, transp=90)
fill(midPricePlot, shortStopPlot, title='Short State Filling', color=shortFillColor, transp=90)

changeCond = dir != dir[1]
alertcondition(changeCond, title='Alert: CE Direction Change', message='Chandelier Exit has changed direction!')
alertcondition(buySignal, title='Alert: CE Buy', message='Chandelier Exit Buy!')
alertcondition(sellSignal, title='Alert: CE Sell', message='Chandelier Exit Sell!')

//END OF CE STOP

//********************************

//CHANDELIER EXIT STRAT2
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
plotshape(buySignal2 ? longStop2 : na, title='Long Stop Start 2', location=location.absolute, style=shape.circle, size=size.tiny, color=longColor2, transp=0)
plotshape(buySignal2 and showLabelsCE2 ? longStop2 : na, title='Buy Label 2', text='Buy 2', location=location.absolute, style=shape.labelup, size=size.tiny, color=longColor2, textcolor=color.new(color.white, 0), transp=0)

shortStopPlot2 = plot(dir2 == 1 ? na : shortStop2, title='Short Stop 2', style=plot.style_linebr, linewidth=2, color=shortColor2)
sellSignal2 = dir2 == -1 and dir2[1] == 1
plotshape(sellSignal2 ? shortStop2 : na, title='Short Stop Start 2', location=location.absolute, style=shape.circle, size=size.tiny, color=shortColor2, transp=0)
plotshape(sellSignal2 and showLabelsCE2 ? shortStop2 : na, title='Sell Label 2', text='Sell 2', location=location.absolute, style=shape.labeldown, size=size.tiny, color=shortColor2, textcolor=color.new(color.white, 0), transp=0)

midPricePlot2 = plot(ohlc4, title='', style=plot.style_circles, linewidth=0, display=display.none, editable=false)

longFillColor2 = highlightStateCE2 ? dir == 1 ? longColor2 : na : na
shortFillColor2 = highlightStateCE2 ? dir == -1 ? shortColor2 : na : na
fill(midPricePlot2, longStopPlot2, title='Long State Filling 2', color=longFillColor2, transp=90)
fill(midPricePlot2, shortStopPlot2, title='Short State Filling 2', color=shortFillColor2, transp=90)

changeCond2 = dir2 != dir2[1]
alertcondition(changeCond2, title='Alert: CE 2 Direction Change', message='Chandelier Exit 2 has changed direction!')
alertcondition(buySignal2, title='Alert: CE 2 Buy', message='Chandelier Exit 2 Buy!')
alertcondition(sellSignal2, title='Alert: CE 2 Sell', message='Chandelier Exit 2 Sell!')

//END OF CE2 STOP

//******************************


//ZLSMA
plot(zlsma, title='zlsma', color=color.new(color.black, 50), linewidth=4)

//EMA20
plot(ema20, title='ema 20', color=color.new(color.yellow, 0), linewidth=1)

//EMA50
plot(ema50, title='ema 50', color=color.new(color.blue, 0), linewidth=1)

//EMA100
plot(ema100, title='ema 100', color=color.new(color.green, 0), linewidth=3)

//EMA200
plot(ema200, title='ema 200', color=color.new(color.orange, 0), linewidth=3)

