QUnit.module \Timers

G = global? && global || window

eq = strictEqual

timeLimitedPromise = (time, fn)-> Promise.race [new Promise(fn), new Promise (res, rej)-> setTimeout rej, time]

test 'setTimeout / clearTimeout' !->
  it.expect 2
  
  timeLimitedPromise(1e3, (res)-> G.setTimeout(((a, b)-> res a +  b), 10 \a \b))
    .then  -> eq it, \ab, 'setTimeout works with additional args'
    .catch -> ok no 'setTimeout works with additional args'
    .then it.async!
  
  timeLimitedPromise(50, (res)-> clearTimeout G.setTimeout res, 10)
    .then  -> ok no 'clearImmediate works with wraped setTimeout'
    .catch -> ok on 'clearImmediate works with wraped setTimeout'
    .then it.async!

test 'setInterval / clearInterval' !->
  it.expect 1
  i = 0
  timeLimitedPromise(5e3, (res, rej)-> interval = G.setInterval(((a, b)->
    if a + b isnt \ab or i > 5 => rej {a, b, i}
    if i++ is 5
      clearInterval interval
      setTimeout res, 30
  ), 4 \a \b))
    .then  -> ok on 'setInterval & clearInterval works with additional args'
    .catch ({a, b, i} = {})-> ok no "setInterval & clearInterval works with additional args: #a, #b, times: #i"
    .then it.async!