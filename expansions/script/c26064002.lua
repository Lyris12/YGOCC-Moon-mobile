--Over-Wind Olomouc
function c26064002.initial_effect(c)
--flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(26064002,2))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(c26064002.fltg)
    e1:SetOperation(c26064002.flipop)
    c:RegisterEffect(e1)
--flip
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetOperation(c26064002.flip)
    c:RegisterEffect(e2)
--leave field
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(26064001,3))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c26064002.setcon1)
    e3:SetOperation(c26064002.setop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_LEAVE_FIELD)
    e4:SetCondition(c26064002.setcon2)
    c:RegisterEffect(e4)
end
function c26064002.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x664)
end
function c26064002.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if e:GetHandler():GetFlagEffect(26064004)~=0 then
        Duel.SetChainLimit(aux.FALSE)
        Duel.Hint(HINT_CARD,0,26064004)
    end
end
function c26064002.flipop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsType),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
    local g2=Duel.GetMatchingGroup(c26064002.filter,tp,LOCATION_DECK,0,nil,c)
    if g1:GetCount()>0 and c:GetFlagEffect(26064002)~=0 and Duel.SelectYesNo(tp,aux.Stringid(26064002,0)) then 
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064002,1))
        local sg=g1:Select(tp,1,1,nil)
        if sg then
            Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
        end
    else
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26064002,1))
        local sg=g2:Select(tp,1,1,nil)
        tg=sg:GetFirst()
        if tg then
            Duel.ShuffleDeck(tp)
            Duel.MoveSequence(tg,0)
            Duel.ConfirmDecktop(tp,1)
        end
    end
end
function c26064002.flip(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():RegisterFlagEffect(26064002,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c26064002.setcon1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c26064002.setcon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c26064002.setfilter(c)
    return c:IsMSetable(true,nil) or c:IsSSetable()
end
function c26064002.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c26064002.setfilter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()>0 and c:IsRelateToEffect(e) then
        Duel.Hint(HINT_SELECTMSG,tp,527)
        local sg=g:Select(tp,1,1,nil)
        local tc=sg:GetFirst()
        local s1=tc:IsMSetable(true,nil)
        local s2=tc:IsSSetable()
        if (s1 and s2) or not s2 then
            Duel.MSet(tp,tc,true,nil)
            Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        else
            Duel.SSet(tp,tc)
        end
    end
end