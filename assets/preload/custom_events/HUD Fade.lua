function onEvent(eventName, value1, value2)
    if eventName=='HUD Fade' then
        if value1=='0' then
            doTweenAlpha('AlphaCam','camHUD',1,crochet/1000,'linear')
            doTweenAlpha('AlphaCamGame','camGame',1,crochet/1000,'linear')
        elseif value1=='1' then
            setProperty('camGame.alpha',0)
            setProperty('camHUD.alpha',0)
        end
    end
end